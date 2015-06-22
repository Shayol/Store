class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validate :price, presence: true, numericality: true
  validate :quantity, :price, presence: true

  before_save do
    self.price = self.book.price
  end
end
