class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  attr_accessor :old_password, :new_password

  has_one    :credit_card, dependent: :destroy
  has_many   :orders, dependent: :destroy
  has_many   :raitings, dependent: :destroy
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :firstname, length: { maximum: 200 }
  validates :lastname, length: { maximum: 200 }

  def self.from_omniauth(auth)
    unless user = where(provider: auth.provider, uid: auth.uid).first
      user = new unless user = find_by(email: auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.confirmed_at = Time.now.utc
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.save!
      user
    else
      user
    end
end

  def update_settings
    if !guest?
      if !billing_address_id
        update_attribute(:billing_address_id, current_order.billing_address_id)
      end
      if !shipping_address_id
        update_attribute(:shipping_address_id, current_order.shipping_address_id)
      end
    end
  end

  def current_order
    order = orders.in_progress.first
    order.nil? ? orders.create : order
  end

  def guest?
    email.match(/example.com/)
  end

end
