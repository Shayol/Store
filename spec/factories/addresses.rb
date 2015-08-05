FactoryGirl.define do

  factory :address do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    phone { Faker::PhoneNumber.cell_phone }
    country nil
  end
end