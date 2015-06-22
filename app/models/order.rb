class Order < ActiveRecord::Base

  ORDER_STATE = ["in progress", "completed", "shipped"]

  has_many :order_items
  has_many :books, :through => :order_items
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :total_price, presence: true
  validates :completed_date, presence: true, if: :status_completed?
  validates :state, inclusion: { in: ORDER_STATE }, presence: true

  before_save do
    self.update_attribute(:total_price, set_total_price) #MAKE THIS WORK ON ADDING ASSOCIOATIONS
  end

  scope :in_progress, -> {where(state: ORDER_STATE[0])}


def status_completed?
    true if self.state == ORDER_STATE[1]
  end

  def order_book(book, quantity=1)
    if self.order_items.any?
      self.order_items.first.increment!(:quantity, quantity)
    else
      self.order_items.create(price: book.price, quantity: quantity, book_id: book.id)
    end
    self.save
  end

  def set_total_price
    45.55
    # sum=0
    # self.order_items.inject(sum){|sum, item| sum + item.price * item.quantity}
  end

end
