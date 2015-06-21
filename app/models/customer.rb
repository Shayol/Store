class Customer < ActiveRecord::Base
  has_many :orders


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX,
    message: "wrong symbols in your email" }, length: { maximum: 100 }, uniqueness: true, presence: true
  validates :firstname, length: { maximum: 500 }
  validates :lastname, length: { maximum: 500 }
  validates :password, length: { in: 6..20 }, confirmation: true

  def current_order
    self.orders.find_by(state: "in progress")
  end

end


