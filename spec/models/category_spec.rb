require 'rails_helper'

RSpec.describe Category, type: :model do
  it { should have_many(:books) }
  it { should validate_presence_of(:title) }
  it { should validate_uniqueness_of(:title) }
end
