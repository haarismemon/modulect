class Tag < ApplicationRecord

  VALID_TYPES_REGEX = /CareerTag|InterestTag/
  validates :name, presence: true
  validates :type, presence: true, format: { with: VALID_TYPES_REGEX }

  has_and_belongs_to_many :uni_modules

end
