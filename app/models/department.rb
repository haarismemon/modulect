class Department < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_many :users
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :uni_modules
  has_one :notice

  belongs_to :faculty, optional: true

  # Registers a course as belonging to this department.
  def add_course(valid_course)
    courses << valid_course
  end

  def self.to_csv
    attributes = %w{name}
    CSV.generate(headers:true)do |csv|
      csv << [attributes.first.capitalize,'Faculty']
      all.each do |dept|
        csv << dept.attributes.values_at(*attributes) + [*Faculty.find(dept.faculty_id).name]
      end
    end
  end
end
