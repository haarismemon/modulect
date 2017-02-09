class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8},:uniqueness => true

  has_many :taggings
  has_many :tags, through: :taggings
end
