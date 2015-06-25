require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it { should have_many(:orders) }
  it { should belong_to(:customer) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:expiration_month) }
  it { should validate_presence_of(:expiration_year) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:CVV) }
end
