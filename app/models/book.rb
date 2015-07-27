class Book < ActiveRecord::Base

  mount_uploader :image, ImageUploader

  belongs_to :author
  belongs_to :category
  has_many :raitings
  # has_many :customers, :through => :raitings

  validates :title, :price, :amount, presence: true

   paginates_per 9

end
