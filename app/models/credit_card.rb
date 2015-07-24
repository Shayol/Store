class CreditCard < ActiveRecord::Base
  belongs_to :user
  has_many :orders

  validates :number, :expiration_month, :expiration_year, :firstname, :lastname, :CVV, presence: true
end
