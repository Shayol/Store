require 'rails_helper'

RSpec.describe Delivery, type: :model do
  it { should have_many(:orders) }
end
