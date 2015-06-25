class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many :orders

  validates :number, :expiration_month, :expiration_year, :firstname, :lastname, :CVV, presence: true
end
