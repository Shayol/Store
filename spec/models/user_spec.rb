require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:raitings) }
  it { should have_many(:orders) }
  it { should have_many(:credit_cards) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_length_of(:email).is_at_most(100) }
  it { should validate_length_of(:firstname).is_at_most(500) }
  it { should validate_length_of(:lastname).is_at_most(500) }
  it{ should validate_presence_of :firstname }
  it{ should validate_presence_of :lastname }

  let(:order) { create :order, user: subject }

  describe "#current_order" do
    it "returns current order" do
      expect(subject.current_order).to eq(order)
    end
 
   it "returns only order that has state - in_progress" do
     order_not_in_progress = create :order, user: subject, state: "in_queue"
     expect(subject.current_order).not_to eq(order_not_in_progress)
   end
  end

  describe ".from_omniauth" do
    let(:facebook_user) { create :facebook_user }
    let(:user_attr)     { attributes_for :facebook_user }

    it "returns user if one exists with same uid and provider" do
      auth = double("auth")
      allow(auth).to receive(:provider).and_return(facebook_user.provider)
      allow(auth).to receive(:uid).and_return(facebook_user.uid)
      expect(User.from_omniauth(auth)).to eq facebook_user
    end

    it "checks facebook's email and connects to the existing account with same email" do
      auth = double("auth", provider: user_attr[:provider],
                            uid:      user_attr[:uid],
                            info:     double("info", email:     subject.email,
                                                     firstname: user_attr[:firstname],
                                                     lastname:  user_attr[:lastname],
                                            )
                    )
      expect(User.from_omniauth(auth)).to eq subject
    end


    it "creates new user" do
      auth = double("auth", provider: user_attr[:provider],
                            uid:      user_attr[:uid],
                            info:     double("info", email:     user_attr[:email],
                                                     firstname: user_attr[:firstname],
                                                     lastname:  user_attr[:lastname],
                                            )
                    )

      expect { User.from_omniauth(auth) }.to change { User.count }.by(1)
    end
  end
end

