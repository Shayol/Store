FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.sentence }
    price { Faker::Commerce.price }  # FFaker?
    amount { Faker::Number.number(2) } # FFaker?
  end

end