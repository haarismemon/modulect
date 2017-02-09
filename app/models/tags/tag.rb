class Tag < ApplicationRecord
  VALID_TYPES_REGEX = /Career|Interest/
  validates :name, presence: true
  validates :type, presence: true, format: { with: VALID_TYPES_REGEX }

  has_many :taggings
  has_many :modules, through: :taggings, source: :uni_module
end
