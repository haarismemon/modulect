class YearStructure < ApplicationRecord
  belongs_to :course
  has_many :groups, dependent: :destroy
  validates :year_of_study, presence: true
  validates :course_id, presence: true
  enum year_of_study: { first_year: 1, second_year: 2, third_year: 3,
                        fourth_year: 4, fifth_year: 5, sixth_year: 6,
                        seventh_year: 7 }

  accepts_nested_attributes_for :groups

  # set the maximum year of study
  def self.max_year_of_study
    7
  end

  # check that groups exist for this year structure
  def groups_existent?
    self.groups.count > 0
  end

  # simple method to obtain the year structure as a string
  def to_s
    "#{year_of_study.titleize}"
  end
end
