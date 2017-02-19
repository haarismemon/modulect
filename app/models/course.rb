class Course < ApplicationRecord

  validates :name, presence: true
  validates :year, presence: true

  # There cannot be two entries with same name and year.
  validates :name, uniqueness: { scope: [:year] }

  has_and_belongs_to_many :departments
  has_many :year_structures

  # Registers a department as belonging to this course.
  def add_department(valid_department)
    departments << valid_department
  end
end
