class UniModule < ApplicationRecord
  validates :name, presence: true
  validates :code, presence: true, length: { is: 8},:uniqueness => true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags_tags, :class_name => 'Tags::Tag'

end
