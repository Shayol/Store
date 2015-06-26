require 'rails_helper'

RSpec.describe Order, type: :model do
  # let(:order_item) {create :order_item}

  it { should belong_to(:customer) }
  it { should belong_to(:credit_card) }
  it { should belong_to(:billing_address) }
  it { should belong_to(:shipping_address) }
  it { should have_many(:order_items) }
  it { should have_many(:books) }
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:state) }

  let(:book) {create :book, price: 77}

  subject{create :order}

  describe ".order_book" do
    it "creates new order_item first time book added to the order" do
      subject.order_book(book)
      expect(subject.order_items.count).to eq(1)
    end

    it "changes quantity of existing order_item" do
      subject.order_book(book)
      subject.reload
      subject.order_book(book)
      expect(subject.order_items.first.quantity).to eq(2)
    end
  end

  describe ".set_total_price" do
    it "changes order's total_price every time book added to order" do
      subject.order_book(book)
      expect(subject.total_price).to eq(77)
    end
  end

  describe "Validation" do
    # it "is invalid without total_price" do
    #   expect(build :order, total_price: nil).not_to be_valid
    # end

    # it "is invalid without state" do
    #   expect(build :order, state: nil).not_to be_valid
    # end


    it "creates new order with state: In progress" do
      expect(subject.state).to eq("in progress")
    end

    # it "order's state should be onу of the  ['in progress', 'completed', 'shipped']" do
    #   order= build :order, state: "fakeState"
    #   expect(order).not_to be_valid
    # end

    it "is invalid if it has no completed date while in 'completed' state " do
      order= build :order, state: Order::ORDER_STATE[1], completed_date: nil
      expect(order).not_to be_valid
    end
  end

end
