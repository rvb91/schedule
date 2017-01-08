class Family < ApplicationRecord
  belongs_to :user
  has_many :slots
end
