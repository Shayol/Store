require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
describe "User" do
  describe "abilities" do
    subject(:ability){ Ability.new(user) }
    let(:user){ nil }

    describe "when user is an admin" do
      let(:user){ create :admin }

      it{ should be_able_to(:manage, :all) }
    end

    describe "when user is signed in" do
      let(:user){ create :user }

      context "order" do
        it { should be_able_to(:manage, Order.new(user: user)) }
        it { should_not be_able_to :read, Order.new }
        it { should_not be_able_to :create, Order.new }
        it { should_not be_able_to :edit, Order.new }
        it { should_not be_able_to :delete, Order.new }
      end

      context "credit card" do
        it { should be_able_to(:manage, CreditCard.new(user: user)) }
        it { should_not be_able_to :read, CreditCard.new }
        it { should_not be_able_to :create, CreditCard.new }
        it { should_not be_able_to :edit, CreditCard.new }
        it { should_not be_able_to :delete, CreditCard.new }
      end

      context "address" do
        it { should be_able_to :manage, Address.new(user: user) }
        it { should_not be_able_to :read, Address.new }
        it { should_not be_able_to :create, Address.new }
        it { should_not be_able_to :edit, Address.new }
        it { should_not be_able_to :delete, Address.new }
      end

      context "user" do
        it { should be_able_to :update_address, user }
        it { should be_able_to :settings, user }
        it { should be_able_to :update_email, user }
        it { should be_able_to :update_password, user }
        it { should_not be_able_to :read, User.new }
        it { should_not be_able_to :create, User.new }
        it { should_not be_able_to :edit, User.new }
        it { should_not be_able_to :delete, User.new }
      end

      context "raiting" do
        it { should be_able_to :read, Raiting.new(approved: true) }
        it { should be_able_to :create, Raiting.new(user: user) }
        it { should_not be_able_to :read, Raiting.new }
        it { should_not be_able_to :create, Raiting.new }
        it { should_not be_able_to :edit, Raiting.new }
        it { should_not be_able_to :delete, Raiting.new }
      end

      context "wish list" do
        it { should be_able_to :edit, WishList.new(user: user)}
        it { should be_able_to :read, WishList.new }
        it { should_not be_able_to :create, WishList.new }
        it { should_not be_able_to :edit, WishList.new }
        it { should_not be_able_to :delete, WishList.new }
      end
    end
      describe "when user is a guest" do
        let(:user) (create :user, email: "guest_#{Time.now.to_i}#{rand(100)}@example.com")

        context "user" do
          it { should_not be_able_to :update_address, User.new }
          it { should_not be_able_to :settings, User.new }
          it { should_not be_able_to :update_email, User.new }
          it { should_not be_able_to :update_password, User.new }
          it { should_not be_able_to :read, User.new }
          it { should_not be_able_to :create, User.new }
          it { should_not be_able_to :edit, User.new }
          it { should_not be_able_to :delete, User.new }
      end

      context "raiting"
        it { should be_able_to :read, Raiting.new(approved: true) }
        it { should_not be_able_to :read, Raiting.new }
        it { should_not be_able_to :create, Raiting.new(user: user) }
        it { should_not be_able_to :create, Raiting.new }
        it { should_not be_able_to :edit, Raiting.new }
        it { should_not be_able_to :delete, Raiting.new }
      end

      end
  end
end
end