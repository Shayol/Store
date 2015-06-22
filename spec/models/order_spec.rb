require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order_item) {create :order_item}

  subject{create :order}

  describe "before_save" do
    it "sets total_price on creation" do
      expect(order.total_price).to eq(order_item.price)
    end

    it "changes total_price on every update" do
    end
  end

end
