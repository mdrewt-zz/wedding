class Reservation < ActiveRecord::Base
  has_many :guests, dependent: :destroy
  accepts_nested_attributes_for :guests, allow_destroy: true
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates_inclusion_of :attending, in: [0, 1]

  def full_name
    "#{first_name} #{last_name}"
  end
end
