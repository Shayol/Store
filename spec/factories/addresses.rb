FactoryGirl.define do

  factory :address do
    address { FFaker::Address.street_address }
    zip_code { FFaker::Address.zip_code }
    city { FFaker::Address.city }
    phone { FFaker::PhoneNumber.phone_number }
    country #{ Country.new name: FFaker::Address.country }
  end
end