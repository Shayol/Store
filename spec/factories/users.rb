FactoryGirl.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(8, 20)}
    password_confirmation { |u| u.password }
    confirmed_at { Time.now }

    factory :facebook_user do
      provider "facebook"
      uid { Faker::Number.number(15) }
    end
  end

end