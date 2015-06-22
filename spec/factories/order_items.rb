FactoryGirl.define do
  factory :order_item do
    price { FFaker::Commerce.price }
    quantity { FFaker::Number.number(1) }
    order
  end

end