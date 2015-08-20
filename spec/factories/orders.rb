FactoryGirl.define do
  factory :order do
    total_price { Faker::Commerce.price }
    completed_date { Faker::Time.between(3.days.ago, Time.now) }
    state "in_progress"
    user nil
    delivery nil
  end

end