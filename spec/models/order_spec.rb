require 'rails_helper'

RSpec.describe Order, type: :model do
  # let(:order_item) {create :order_item}

  it { should belong_to(:user) }
  it { should belong_to(:credit_card) }
  it { should belong_to(:billing_address) }
  it { should belong_to(:shipping_address) }
  it { should have_many(:order_items) }
  it { should have_many(:books) }
  it { should validate_presence_of(:total_price) }
  it { should validate_presence_of(:state) }

  let(:book) {create :book, price: 77}

  #subject{create :order}

  describe "#order_book" do
    it "creates new order_item first time book added to the order" do
      subject.order_book(book)
      expect(subject.order_items.count).to eq(1)
    end

    It "adds price of a book to order total_price" do
      subject.order_book(book)
      expect(subject.total_price).to eq(book.price)
    end

    it "changes quantity of existing order_item" do
      subject.order_book(book)
      subject.reload
      subject.order_book(book)
      expect(subject.order_items.first.quantity).to eq(2)
    end
  end

  describe "#set_total_price" do
    it "changes order's total_price every time book added to order" do
      subject.order_book(book)
      expect(subject.total_price).to eq(77)
    end
  end

  describe "Validation" do
   it "is invalid without total_price" do
      expect(build :order, total_price: nil).not_to be_valid
    end

    it "is invalid without state" do
      expect(build :order, state: nil).not_to be_valid
    end

    it "is invalid if it has no completed date while in 'confirmed' state " do
      order = build :order, state: "confirmed", completed_date: nil
      expect(order).not_to be_valid
    end
  end

  describe "#current_order?"
    it "returns true if self in state: In progress" do
        expect(subject.current_order?).to eq(true)
    end

    it "returns false if self is not in state: In progress" do
      order = create :order, state: "in_queue"
      expect(subject.current_order?).to eq(true)
    end
  end

  describe "#merge" do
    let(:first_order) { create :order }
    let(:first_order_item)  { create :order_item, book: book, order: first_order, quantity: 1 }
    let(:other_order) { create :order }
    let(:other_order_item)  { create :order_item, book: book, order: other_order, quantity: 1 }

    it "adds books in guest order to same books of signed in user" do
      first_order.merge other_order
      expect(first_order.order_items.first.quantity).to eq(first_order_item.quantity + other_order_item.quantity)
      expect(first_order.books).to eq(other_order.books)
    end
  end

  describe "#set_total_price" do
    it "updates total sum of order" do
      order_item = create :order_item, order: subject
      expect { subject.set_total_price }.to change { subject.total_price }.by(order_item.price * order_item.quantity)
    end
  end

end
