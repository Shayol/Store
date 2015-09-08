class Book < ActiveRecord::Base
  include PgSearch

  mount_uploader :image, ImageUploader

  belongs_to :author
  belongs_to :category
  has_many :raitings

  validates :title, :price, :amount, presence: true

  paginates_per 9

  pg_search_scope :search,
                  against: [:title],
                  associated_against: {
                  author: [:firstname, :lastname] },
                  :using => {
                  :tsearch => {:prefix => true}
                  }

end
