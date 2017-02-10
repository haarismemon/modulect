class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8 }, uniqueness: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  # Registers a tag as belonging to this module.
  def add_tag(valid_tag)
    tags << valid_tag
  end
end
