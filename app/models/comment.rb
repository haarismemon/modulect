class Comment < ApplicationRecord
  belongs_to :uni_module

  validates :rating, :inclusion => 1..5
end
