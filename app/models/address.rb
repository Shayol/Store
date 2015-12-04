class Address < ActiveRecord::Base
  has_many  :users
  validates :address, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :phone, presence: true, length: { minimum: 5, maximum: 12 }
  validates :lastname, presence: true
  validates :firstname, presence: true
  validates :country, presence: true
end
