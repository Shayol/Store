class Raiting < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book

  validates :raiting_number, inclusion: {in: (1..10)}
  scope :approved_by_admin, -> {where(approved: true)}
end
