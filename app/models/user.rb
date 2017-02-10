class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, :uniqueness => true
  validates :username, presence: true, :uniqueness => true
  validates :password_digest, presence: true
  validates :user_level, length: { is: 1}
  validates :year_of_study, presence: true, length: { is: 1}
  default_value_for :user_level, 3  #student #(needs testing)
  default_value_for :entered_before, false  #(needs testing)

  has_and_belongs_to_many :uni_modules

  def full_name
    "#{first_name} #{last_name}"
  end

end
