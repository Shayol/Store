class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  has_one    :credit_card
  has_many   :orders
  has_many   :raitings
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :firstname, length: { maximum: 200 }
  validates :lastname, length: { maximum: 200 }


  def self.from_omniauth(auth)
    unless where(provider: auth.provider, uid: auth.uid).first
      user = new unless user = find_by(email: auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.confirmed_at = Time.now.utc
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.save!
    end
end

end
