class Customer < ActiveRecord::Base
  has_many :orders
  has_many :raitings
  has_many :customers, :through => :raitings
  has_many :credit_cards

  validates :firstname, length: { maximum: 500 }, presence: true
  validates :lastname, length: { maximum: 500 }, presence: true
  validates :password, length: { in: 6..20 }, confirmation: true, presence: true

  def current_order
    orders.in_progress.first
  end

  def new_order
    orders.new
  end

end


