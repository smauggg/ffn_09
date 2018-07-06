class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable,
    :lockable, :confirmable, :async
  devise :omniauthable, omniauth_providers: %i(facebook google_oauth2)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_COIN_REGEX = /\A\d{1,8}(\.\d{0,2})?\z/

  has_many :news
  has_many :comments
  has_many :bets

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.user_email_maxlen},
    presence: true, uniqueness: {case_sensitive: false}

  validates :password, length: {minimum: Settings.user_password_minlen},
    presence: true, on: :create

  validates :password, length: {minimum: Settings.user_password_minlen},
    allow_blank: true, on: :update

  validates :name, length: {maximum: Settings.user_name_maxlen},
    presence: true

  validates :coin, format: {with: VALID_COIN_REGEX},
    numericality: true

  validates :address, presence: true

  validates :password_confirmation, presence: true, on: :create

  enum role: %i(member admin)

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.from_omniauth auth
    where(email: auth.info.email).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
    end
  end

  def self.new_with_session params, session
    super.tap do |user|
      data = session["devise.data"]
      if data.present?
        user.email = data["info"]["email"] if user.email.blank?
        user.name = data["info"]["name"] if user.name.blank?
        user.skip_confirmation!
      end
    end
  end
end
