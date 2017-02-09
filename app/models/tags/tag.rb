class Tag < ApplicationRecord

  VALID_TYPES_REGEX = /Career|Interest/
  validates :name, presence: true
  validates :type, presence: true, format: { with: VALID_TYPES_REGEX }

  has_many :taggings
  has_many :modules, through: :taggings, source: :uni_module

  def add_module(valid_uni_module)
    Tagging.create(tag_id: self.id, uni_module_id: valid_uni_module.id)
  end
end
