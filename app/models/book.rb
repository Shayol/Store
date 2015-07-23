class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many :raitings
  # has_many :customers, :through => :raitings

  validates :title, :price, :amount, presence: true

end
