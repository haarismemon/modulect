class Department < ApplicationRecord

  validates :name, presence: true, uniqueness: true
  has_many :users
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :uni_modules
  belongs_to :faculty, optional: true

  # Registers a course as belonging to this department.
  def add_course(valid_course)
    courses << valid_course
  end

  def self.to_csv
    base_attributes = %w{name}
    csv_header = ["Name", "Faculty"]

    CSV.generate(headers:true) do |csv|
      csv << csv_header.each { |att| att.titleize }

      all.each do |department|
        to_append = department.attributes.values_at(*base_attributes)

        to_append << department.faculty.to_s

        csv << to_append
      end
    end
  end

  def to_s
    name
  end
end
