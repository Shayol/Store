class Country < ActiveRecord::Base
  validate :name, uniqueness: true, presence: true
end
