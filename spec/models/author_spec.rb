require 'rails_helper'

RSpec.describe Author, type: :model do
  it { should have_many(:books) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
end
