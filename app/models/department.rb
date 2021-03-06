class Department < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_many :users
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :uni_modules
  has_many :notices, dependent: :destroy

  belongs_to :faculty, optional: true

  # Registers a course as belonging to this department.
  def add_course(valid_course)
    courses << valid_course
  end

   # CSV export, loops over the department record obtaining the individual columns from the database
   def self.to_csv
    attributes = %w{name}
    CSV.generate(headers:true)do |csv|
      csv << [attributes.first,'faculty_name']
      all.each do |dept|
        csv << dept.attributes.values_at(*attributes) + [*Faculty.find(dept.faculty_id).name]
      end
    end
  end

  def to_s
    name
  end
end
