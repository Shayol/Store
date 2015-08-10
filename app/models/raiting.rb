class Raiting < ActiveRecord::Base
  belongs_to :user
  belongs_to :book

  validates :raiting_number, inclusion: {in: (1..5)}
  scope :approved_by_admin, -> {where(approved: true)}
end
