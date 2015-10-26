require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should have_many(:users) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:zipcode) }
  it { should validate_presence_of(:phone) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:firstname) }
end
