class Ability
  include CanCan::Ability

  def initialize user
    can :read, :all
    return if user.blank?
    if user.admin?
      can :manage, :all
    else
      can %i(create update), Bet, user_id: user.id
      can :manage, Comment, user_id: user.id
      can :update, User, user_id: user.id
    end
  end
end
