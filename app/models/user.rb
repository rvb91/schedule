class User < ApplicationRecord

  has_one :nanny, dependent: :destroy

  validates :name, presence:true
  validates :default_type, presence:true, inclusion: { in: %w(nanny family) }

  after_commit :create_nanny_or_family, on: [:create]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # removed :recoverable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable


  private
  def create_nanny_or_family
    case default_type
    when "nanny"
      self.create_nanny!
    when "family"
      # user.create_family
    else
      raise StandardError.new("Attribute default type is not set or invalid")
    end
  end
end
