class User < ApplicationRecord

  has_one :nanny, dependent: :destroy
  has_one :family, dependent: :destroy

  validates :name, presence:true
  validates :default_type, presence:true, inclusion: { in: %w(nanny family) }

  after_commit :create_nanny_or_family, on: [:create]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable


  def is_nanny?
    "nanny" == default_type
  end

  def is_family?
    "family" == default_type
  end

  private
  def create_nanny_or_family
    case default_type
    when "nanny"
      self.create_nanny!
    when "family"
      self.create_family!
    else
      raise StandardError.new("Attribute default type is not set or invalid")
    end
  end
end
