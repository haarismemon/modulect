class Comment < ApplicationRecord
  belongs_to :uni_module

  validates :commenter, :presence => true
  validates :rating, :inclusion => 1..5
  validates :body, :presence => true
end
