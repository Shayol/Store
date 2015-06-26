require 'rails_helper'

RSpec.describe Customer, type: :model do
  it { should have_many(:raitings) }
  it { should have_many(:orders) }
  it { should have_many(:credit_cards) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:email).is_at_most(100) }
  it { should validate_length_of(:firstname).is_at_most(500) }
  it { should validate_length_of(:lastname).is_at_most(500) }
  it do
    should validate_length_of(:password).
      is_at_least(6).is_at_most(20)
  end

  it { should validate_confirmation_of(:password).on(:create) }

  subject{create :customer}

  describe ".current_order" do
    it "finds current order in progress" do
      order= create :order, customer: subject
      expect(subject.current_order).to eq(order)
    end
  end

  describe ".new_order" do
    it "creates new order" do
      expect(subject.new_order.class).to eq(Order)
    end
  end

  describe "scope: In progress" do
    it "fetches only orders 'in progress'" do
      completed_order = create :order, state: Order::ORDER_STATE[1], customer: subject
      new_order = create :order, customer: subject
      expect(subject.orders.in_progress).not_to include(Order::ORDER_STATE[1])
    end
  end
end
