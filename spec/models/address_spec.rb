require 'rails_helper'

RSpec.describe Address, type: :model do
  it { should belong_to(:country) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:zipcode) }
  it { should validate_presence_of(:phone) }
end
