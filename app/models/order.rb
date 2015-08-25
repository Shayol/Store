class Order < ActiveRecord::Base
  include AASM

  ORDER_STATE = ["in_progress", "address", "type_of_delivery", "payment",
                 "confirm", "in_queue", "in_delivery", "delivered", "canceled"]

  has_many   :order_items, dependent: :destroy
  has_many   :books, :through => :order_items
  belongs_to :user
  belongs_to :delivery
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validates :state, inclusion: { in: ORDER_STATE }, presence: true

  # Validations happens only after appropriate state of order
  validates :total_price, :order_items, :books, :billing_address_id, :shipping_address_id,
                             presence: true, if: Proc.new { |a| a.address? || a.confirm?}
  validates :delivery_id,    presence: true, if: Proc.new { |a| a.type_of_delivery? || a.confirm?}
  validates :credit_card_id, presence: true, if: Proc.new { |a| a.payment? || a.confirm?}
  validates :completed_date, presence: true, if: Proc.new { |a| a.confirm? }


  scope :in_progress,  -> {where(state: ["in_progress", "address", "type_of_delivery", "payment"])}
  scope :in_queue,     -> {where(state: ["confirm", "in_queue"])}
  scope :in_delivery,  -> {where(state: "in_delivery")}
  scope :delivered,    -> {where(state: "delivered")}

  aasm  :column => 'state' do
    state :in_progress, :initial => true
    state :address
    state :type_of_delivery
    state :payment
    state :confirm
    state :in_queue
    state :in_delivery
    state :delivered
    state :canceled


    event :address_event do
      transitions :from => :in_progress, :to => :address
    end

    event :type_of_delivery_event, :after => :add_delivery_price do
      transitions :from => :address, :to => :type_of_delivery
    end

    event :payment_event do
      transitions :from => :type_of_delivery, :to => :payment
    end

    event :confirm_event, :after => [:update_user_address, :notify_user] do
      transitions :from => :payment, :to => :confirm
    end

    # event :cancel do
    #   transitions :from => [:in_queue, :in_delivery], :to => :canceled
    # end
    # event :finish do
    #   transitions :from => :in_delivery, :to => :delivered
    # end

  end

  def notify_user
    #send mail with order info
  end

  def update_user_address
    user.update_settings unless user.guest?
  end

  def add_delivery_price
    set_total_price
  end

  # def order_in_queue?
  #   state == "in_queue"
  # end

  # def order_confirm?
  #   state == "confirm"
  # end

  # def delivery_or_confirm?
  #   state.include?('delivery') || order_confirm?
  # end

  # def address_or_confirm?
  #   state.include?('address') || order_confirm?
  # end

  # def card_or_confirm?
  #   state.include?('payment') || order_confirm?
  # end


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
