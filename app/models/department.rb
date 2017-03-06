class Department < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  belongs_to :user
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :uni_modules
  belongs_to :faculty, optional: true
  # Registers a course as belonging to this department.
  def add_course(valid_course)
    courses << valid_course
  end

end
