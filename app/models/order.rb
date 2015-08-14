class Order < ActiveRecord::Base

  ORDER_STATE = ["in_progress", "in_queue", "in_delivery", "delivered", "canceled"]

  has_many :order_items, dependent: :destroy
  has_many :books, :through => :order_items
  belongs_to :user
  belongs_to :delivery
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :total_price, :order_items, :books, :credit_card, :billing_address, :shipping_address, presence: true, if: :order_in_queue?
  validates :completed_date, presence: true, if: :status_completed?
  validates :state, inclusion: { in: ORDER_STATE }, presence: true

  scope :in_progress, -> {where(state: ORDER_STATE[0])}
  scope :in_queue, -> {where(state: ORDER_STATE[1])}
  scope :in_delivery, -> {where(state: ORDER_STATE[2])}
  scope :delivered, -> {where(state: ORDER_STATE[3])}

  def status_completed?
    state == ORDER_STATE[1]
  end

  # def order_in_delivery?
  #   state == ORDER_STATE[2]
  # end
  def order_in_queue?
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

  def set_total_price
    sum = items_price
    sum += delivery.price if delivery && order_items.any?
    self.update_attribute(:total_price, sum)
  end

  def merge guest_order
    user_order_items = order_items
    guest_order.order_items.each do |order_item|
      if self.books.include? order_item.book
        user_order_item = user_order_items.find_by(book_id: order_item.book_id)
        user_order_item.update(quantity: (order_item.quantity + user_order_item.quantity))
     else
        order_item.order_id = self.id
        order_item.save
      end
    end
  end

end
