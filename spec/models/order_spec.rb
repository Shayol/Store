require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order_item) {create :order_item}
  let(:book) {create :book, price: 77}

  subject{create :order}

  describe ".order_book" do
    it "calls method set_total_price" do
      subject.order_book(book)
      expect(subject.order_book).to eq(77)
    end
  end

  # describe "before_save" do
  #   it "sets total_price on creation" do
  #     expect(order.total_price).to eq(order_item.price)
  #   end

  #   it "changes total_price on every update" do
  #   end
  # end

end
