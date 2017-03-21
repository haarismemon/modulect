class Course < ApplicationRecord

  validates :name, presence: true
  validates :year, presence: true
  validates :duration_in_years, presence: true
  validates :duration_in_years, numericality: { greater_than_or_equal_to: 1, 
                                                less_than_or_equal_to: YearStructure.max_year_of_study}

  # There cannot be two entries with same name and year.
  validates :name, uniqueness: { scope: [:year] }
  # Recommended pathways
  has_many :pathways
  has_many :suggested_pathways
  has_and_belongs_to_many :departments

  has_many :year_structures, dependent: :delete_all
  has_many :groups, through: :year_structures
  has_many :uni_modules, through: :groups

  accepts_nested_attributes_for :year_structures

  has_many :users

  # creates year structures for a course
  def create_year_structures
    for y in 1..self.duration_in_years
      self.year_structures << YearStructure.create(year_of_study: y)
    end
  end

  # updates the year structures
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
    elsif duration_in_years_post_update < duration_in_years_pre_update
      (duration_in_years_pre_update - duration_in_years_post_update).times do
        self.year_structures.last.destroy
      end
    end
  end

  # checks that all year structures have been well-defined. if not this is used to show a warning in the admin area
  def all_year_structures_defined?
    self.year_structures.each_with_index do |year_structure, index|
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

  # CSV export, loops over the course record obtaining the individual columns from the database
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
        department_names.chop!
            if department_names!=''
                  department_names.chop!
            end
        department_names[0] = ''
        csv << course.attributes.values_at(*attributes) + [*department_names]
      end
    end
  end

  def to_s
    name
  end
end
