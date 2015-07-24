class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)
    if user && user.class == Admin
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      can :dashboard
      can :manage, :all
    else
       can [:create, :update, :destroy], [ Address, CreditCard], :user_id => user.id
       can :read, [Book, Category, Order, OrderItem], :user_id => user.id
       can [:update, :create, :destroy], Order, Order.in_progress do |order|
         order.state == Order::ORDER_STATE[0] #???? only his own
    end
    end

    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
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
end
