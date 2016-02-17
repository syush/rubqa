class Ability
  include CanCan::Ability

  attr_accessor :user

  def initialize(user)
    @user = user
    # Define abilities for the passed in user here. For example:
    #
    if user
      if user.admin?
        admin_abilities
      else
        user_abilities
      end
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can [:create, :update, :destroy], [Question, Answer, Vote], user_id: user.id
    can :destroy, Attachment do |attachment|
      attachment.attachable.user_id == user.id
    end
    can :select_as_best, Answer do |answer|
      answer.question.user_id == user.id
    end
    can :me, User, id: user.id

  end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

end
