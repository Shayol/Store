class Order < ActiveRecord::Base

  ORDER_STATE = ["in_progress", "in_queue", "in_delivery", "delivered", "canceled"]

  has_many :order_items, dependent: :destroy
  has_many :books, :through => :order_items
  belongs_to :user
  belongs_to :delivery
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :total_price, presence: true
  validates :order_items, :books, :credit_card, :billing_address, :shipping_address, presence: true, if: :order_in_delivery?
  #validates :completed_date, presence: true, if: :status_completed?
  validates :state, inclusion: { in: ORDER_STATE }, presence: true

  scope :in_progress, -> {where(state: ORDER_STATE[0])}


  # def status_completed?
  #   state == ORDER_STATE[1]
  # end

  def order_in_delivery?
    state == ORDER_STATE[1]
  end

  def order_book(book, quantity=1)
    if item = order_items.find_by(book: book)
      item.increment!(:quantity, quantity)
    else
      order_items.create(price: book.price, quantity: quantity, book_id: book.id)
    end
    set_total_price
  end

  def items_price
    sum = order_items.inject(0) { |sum, item| sum + item.price * item.quantity }
  end

  private

  def set_total_price
    sum = items_price
    sum += current_order.delivery.price if current_order.delivery
    self.update_attribute(:total_price, sum)
  end

end
