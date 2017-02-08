class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, :uniqueness => true
  validates :username, presence: true, :uniqueness => true
  validates :password_digest, presence: true, length: { is: 8}
  validates :user_level, length: { is: 1}
  validates :entered_before
  validates :year_of_study, presence: true, length: { is: 1}
end
