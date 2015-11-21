FactoryGirl.define do
  factory :book do
    title { Faker::Lorem.sentence }
    price { Faker::Commerce.price }
    amount { Faker::Number.number(2) }
    image  nil
    author  
  end

end