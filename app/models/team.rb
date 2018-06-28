class Team < ApplicationRecord
  has_many :players, dependent: :destroy
  has_many :team1_matches, class_name: Match.name, foreign_key: :team1_id
  has_many :team2_matches, class_name: Match.name, foreign_key: :team2_id
  has_many :league_team_join_models, dependent: :destroy
  has_many :leagues, through: :league_team_join_models
  has_many :achievements, dependent: :destroy

  validates :name, presence: true

  scope :alphabet, ->{order name: :asc}
  scope :load_team_from_ids, ->(ids){where "id IN (?)", ids}
  scope :search_by_name, ->(name){where "name LIKE CONCAT('%',?,'%')", name}
  scope :search_by_continent, ->(id){where continent_id: id}
  scope :not_include, ->(teams){Team.all - teams}
  scope :owned_by, ->(league_id){where league_id: league_id}
  scope :owner_country, ->(country_id){where country_id: country_id}
  mount_uploader :picture, PictureUploader
  mount_uploader :logo, LogoUploader
end
