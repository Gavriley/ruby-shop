class Ability
  include CanCan::Ability

  def initialize(user)
    @ability_user = user || User.new

    case @ability_user.role.name
    when 'guest'
      guest_can
    when 'client'
      client_can
    when 'manager'
      manager_can
    when 'admin'
      admin_can
    end
  end

  private

  def admin_can
    manager_can

    can :manage, Comment
    can :manage, Product
  end

  def manager_can
    client_can

    can :destroy, Comment do |comment| comment.product.user == @ability_user || comment.user == @ability_user end

    can :read, Product do |product| product.published == true || product.user == @ability_user end
    can :create, Product
    can :valid_avatar, Product
    can :update, Product, user: @ability_user
    can :destroy, Product, user: @ability_user
  end

  def client_can
    guest_can

    can :create, Comment, product: { published: true }
    can :update, Comment, user: @ability_user
    can :destroy, Comment, user: @ability_user
    can :modal, Comment
  end

  def guest_can
    can :read, Product, published: true
    can :search, Product

    can :read, Category

    can :read, Cart
    can :create, Cart
    can :destroy, Cart
    can :clean, Cart

    can :read, LineItem
    can :create, LineItem
    can :destroy, LineItem
    can :count_up, LineItem
    can :count_down, LineItem

    can :read, Order
    can :create, Order
    can :liqpay_response, Order
    can :paypal_response, Order
    can :stripe_response, Order
    can :modal, Order

    can :read, Comment
  end
end
