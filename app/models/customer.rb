class Customer < ActiveRecord::Base
  has_many :orders
  has_many :raitings
  has_many :customers, :through => :raitings


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX,
    message: "wrong symbols in your email" }, length: { maximum: 100 }, uniqueness: true, presence: true
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


