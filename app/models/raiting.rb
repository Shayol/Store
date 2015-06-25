class Raiting < ActiveRecord::Base
  belongs_to :customer
  belongs_to :book

  validates :raiting_number, inclusion: {in: (1..10)}
end
