class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]

  has_one    :credit_card, dependent: :destroy
  has_many   :orders, dependent: :destroy
  has_many   :raitings, dependent: :destroy
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :firstname, presence: true
  validates :lastname, presence: true

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
      if !billing_address
        billing_address = current_order.billing_address
      end
      if !shipping_address
        shipping_address = current_order.shipping_address
      end
      self.save
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
