class Nanny < ApplicationRecord
  belongs_to :user
  has_many :slots, dependent: :destroy

  validates :user_id, presence: true
end
