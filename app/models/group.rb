class Group < ApplicationRecord
  belongs_to :year_structure
  has_and_belongs_to_many :uni_modules
  validates :name, presence: true
end
