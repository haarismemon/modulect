class UniModule < ApplicationRecord

  validates :name, presence: true
  validates :code, presence: true, length: { is: 8 }, uniqueness: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  # Registers this module as having been tagged with the valid_tag.
  def add_tag(valid_tag)
    tags << valid_tag
  end

  # Registers a user as having selected this module.
  def add_user(valid_user)
    users << valid_user
  end
end
