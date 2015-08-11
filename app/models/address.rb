class Address < ActiveRecord::Base
  belongs_to :country
  has_many :users
  validates :address, presence: true
  validates :zipcode, presence: true
  validates :city, presence: true
  validates :phone, presence: true
  validates :lastname, presence: true
  validates :firstname, presence: true
  validates :country_id, presence: true
end
