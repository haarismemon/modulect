class Comment < ApplicationRecord
  belongs_to :uni_module
  belongs_to :user

  # A comment has many users that liked it
  has_and_belongs_to_many :liked_users, class_name: 'User'

  validates :rating, :inclusion => 1..5
  validates :body, :presence => true
end
