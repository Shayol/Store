require 'rails_helper'

RSpec.describe Raiting, type: :model do
  it { should belong_to(:customer) }
  it { should belong_to(:book) }
  it do
    should validate_inclusion_of(:raiting_number).
      in_range(1..10)
  end
end
