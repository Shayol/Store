require 'rails_helper'

RSpec.describe Raiting, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:book) }
  it { should validate_inclusion_of(:raiting_number).in_range(1..5) }
  it { should validate_presence_of(:raiting_number) }
  it { should validate_presence_of(:review) }
  it { should validate_length_of(:review).is_at_least(2) }

end
