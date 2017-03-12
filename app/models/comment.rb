class Comment < ApplicationRecord
  belongs_to :uni_module
  belongs_to :user

  validates :rating, :inclusion => 1..5
  validates :body, :presence => true
end
