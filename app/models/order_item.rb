class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :price, presence: true, numericality: true
  validates :quantity, :price, presence: true

  # before_save do
  #   self.price = self.book.price
  # end
end
