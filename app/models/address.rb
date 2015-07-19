class Address < ActiveRecord::Base
  belongs_to :country
  has_many :users
  validates :address, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :phone, presence: true
end
