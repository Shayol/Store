class Address < ActiveRecord::Base
  belongs_to :country
  validate :address, presence: true
  validate :zipcode, presence: true
  validate :city, presence: true
  validate :phone, presence: true
end
