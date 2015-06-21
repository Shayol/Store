class Order < ActiveRecord::Base

  has_many :order_items
  has_many :books, :through => :order_items
  belongs_to :customer
  belongs_to :credit_card
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  validate :total_price, presence: true
  validates :completed_date, presence: true, if: :status_completed?
  validate :state, inclusion: { in: ["in progress", "complited", "shipped"]}, presence: true


def status_completed?
    true if self.status == "completed"
  end

  def order_book(book, quantity=1)
    book_items = self.order_items.map{|item| item.book == book}
    if book_items.any?
      book_items.first.increment!(:quantity, quantity)
    else
      self.order_items.create(price: book.price, quantity: quantity, book_id: book.id)
    end
  end

  def set_total_price
    self.order_items.inject(sum=0){|sum, item| sum + item.price * item.quantity}
  end

end
