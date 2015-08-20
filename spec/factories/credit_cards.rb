FactoryGirl.define do
  factory :credit_card do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    number    {Faker::Number.number(16)}
    cvv     {Faker::Number.number(3)}
    expiration_month   {%w(01 02 03 04 04 05 06 07 08 09 10 11 12).sample}
    expiration_year  {rand(15..99)}
    user_id nil
  end
end