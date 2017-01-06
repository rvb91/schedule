class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :recoverable,
  validates :name, presence:true
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable
end
