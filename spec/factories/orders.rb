FactoryGirl.define do
  factory :order do
    total_price { FFaker::Commerce.price }
    completed_date { FFaker::Time.between(2.days.ago, Time.now) }
    state "in progress"
    customer nil
    credit_card nil
  end

end