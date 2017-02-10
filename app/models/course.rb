class Course < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :departments

  # Registers a department as belonging to this course.
  def add_department(valid_department)
    departments << valid_department
  end
end
