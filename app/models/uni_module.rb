class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8},:uniqueness => true

  has_and_belongs_to_many :users

  has_many :taggings
  has_many :tags, through: :taggings

  # Registers a tag as belonging to this module.
  def add_tag(valid_tag)
    Tagging.create(tag_id: valid_tag.id, uni_module_id: self.id)
  end
end
