class Tag < ApplicationRecord

  VALID_TYPES_REGEX = /CareerTag|InterestTag/
  validates :name, presence: true
  validates :type, presence: true, format: { with: VALID_TYPES_REGEX }

  has_and_belongs_to_many :uni_modules

  # Registers a module as belonging to this tag.
  def add_module(valid_uni_module)
    uni_modules << valid_uni_module
  end
end
