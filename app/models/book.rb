class Book < ActiveRecord::Base
  belongs_to :author
  belongs_to :category
  has_many :ratings
  has_many :customers, :through => :ratings

  validates :title, :price, :amount, presence: true

end
