class Family < ApplicationRecord
  belongs_to :user
  has_many :slots

  def name
    user.name
  end
end
