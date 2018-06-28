class Country < ApplicationRecord
  has_many :leagues
  has_many :teams
  has_many :players

  validates :name, length: {maximum: Settings.varchar_maxlen}, presence: true

  scope :alphabet, ->{order name: :asc}
  scope :owner_continent, ->(continent_id){where continent_id: continent_id}
end
