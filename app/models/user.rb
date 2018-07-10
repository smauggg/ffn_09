class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_COIN_REGEX = /\A\d{1,8}(\.\d{0,2})?\z/

  has_many :news
  has_many :comments
  has_many :bets

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.user_email_maxlen},
    presence: true, uniqueness: {case_sensitive: false}

  validates :password, length: {minimum: Settings.user_password_minlen},
    presence: true

  validates :name, length: {maximum: Settings.user_name_maxlen},
    presence: true

  validates :coin, format: {with: VALID_COIN_REGEX},
    numericality: true

  validates :address, presence: true

  validates :password_confirmation, presence: true

  enum role: %i(member admin)

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end
end
