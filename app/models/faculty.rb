class Faculty < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_many :departments

end
