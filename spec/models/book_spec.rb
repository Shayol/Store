require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:raitings) }
  it { should belong_to(:author) }
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:amount) }
end
