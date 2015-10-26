class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.class == Admin
      can :access, :rails_admin       
      can :dashboard
      can :manage, :all
    else
      can :read, WishList
      can :read, Book
      can :add_to_order, Book
      can :manage, OrderItem, :order_id => user.current_order.id
      can :read, Raiting, :approved => true
      can :manage, [ Address, CreditCard, Order], :user_id => user.id
      if !user.guest?
        can :manage, WishList, :order_id => user.current_order.id
        can :settings, User, :user_id => user.id
        can :update_email, User, :user_id => user.id
        can :update_password, User, :user_id => user.id
        can :update_address, User, :user_id => user.id
        # can :edit, User, :user_id => user.id
        # can :read, User, :user_id => user.id
        can :delete, User, :user_id => user.id
        can :create, Raiting, :user_id => user.id
      end
    end
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
