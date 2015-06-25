FactoryGirl.define do
  factory :order do
    total_price { Faker::Commerce.price }
    completed_date { Faker::Time.between(3.days.ago, Time.now) }
    state "in progress"
    customer nil
  end

end