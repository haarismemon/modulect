class Comment < ApplicationRecord
  belongs_to :uni_module
  belongs_to :user

  validates :commenter, :presence => true
  validates :rating, :inclusion => 1..5
  validates :body, :presence => true
end
