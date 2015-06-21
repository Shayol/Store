class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validate :price, presence: true, numericality: true
  validate :quantity, presence: true
end
