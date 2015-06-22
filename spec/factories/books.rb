FactoryGirl.define do
  factory :book do
    title { FFaker::Lorem.sentence }
    price { FFaker::Commerce.price }  # FFaker?
    amount { FFaker::Number.number(2) } # FFaker?
  end

end