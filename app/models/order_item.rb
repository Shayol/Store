class OrderItem < ActiveRecord::Base
  belongs_to :book
  belongs_to :order

  validates :price, presence: true, numericality: true
  validates :quantity, presence: true

  # after_commit :update_order, on: :update

  # def update_order
  #  order.set_total_price
  # end
  # before_save do
  #   self.price = self.book.price
  # end
end
