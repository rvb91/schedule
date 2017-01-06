class User < ApplicationRecord

  validates :name, presence:true
  validates :default_type, presence:true, inclusion: { in: %w(nanny family) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
end
