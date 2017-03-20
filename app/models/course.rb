class Course < ApplicationRecord

  validates :name, presence: true
  validates :year, presence: true
  validates :duration_in_years, presence: true

  # There cannot be two entries with same name and year.
  validates :name, uniqueness: { scope: [:year] }
  # Recommended pathways
  has_many :pathways
  has_and_belongs_to_many :departments

  has_many :year_structures, dependent: :delete_all
  has_many :groups, through: :year_structures
  has_many :uni_modules, through: :groups

  accepts_nested_attributes_for :year_structures

  has_many :users

  def create_year_structures
    for y in 1..self.duration_in_years
      self.year_structures << YearStructure.create(year_of_study: y)
    end
  end

  def update_year_structures(duration_in_years_pre_update)
    if (self.year_structures.empty?)
      create_year_structures
      return
    end
    duration_in_years_post_update = self.duration_in_years
    if duration_in_years_post_update > duration_in_years_pre_update
      last_year_of_study = self.year_structures.last.year_of_study_before_type_cast
      max_year_of_study = YearStructure.max_year_of_study
      for new_year_of_study in last_year_of_study + 1 .. duration_in_years_post_update
        if new_year_of_study <= max_year_of_study
          self.year_structures << YearStructure.create(
                                  year_of_study: new_year_of_study)
        end
      end
    end
  end

  def all_year_structures_defined?
    self.year_structures.each do |year_structure|
      if !year_structure.groups_existent?
        return false
      end
    end
    true
  end

  # Registers a department as belonging to this course.
  def add_department(valid_department)
    departments << valid_department
  end

  def self.to_csv
    attributes = %w{name description year duration_in_years}
    headers = Array.new
    attributes.each{|att| headers.push att}
    headers.push 'departments'
    CSV.generate(headers:true)do |csv|
      csv << headers
      all.each do |course|
        department_names = ' '
        course.departments.pluck(:name).each{|department| department_names += department + '; ' }
        department_names.chop!.chop!
        department_names[0] = ''
        csv << course.attributes.values_at(*attributes) + [*department_names]
      end
    end
  end
end
