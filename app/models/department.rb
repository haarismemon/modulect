class Department < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :uni_modules
  has_and_belongs_to_many :users
  belongs_to :faculty
  # Registers a course as belonging to this department.
  def add_course(valid_course)
    courses << valid_course
  end

end
