class Delivery < ActiveRecord::Base

  has_many :orders

  def decription_and_price
    "#{description} + #{price} "
  end
end
