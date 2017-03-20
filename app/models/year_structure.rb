class YearStructure < ApplicationRecord
  belongs_to :course
  has_many :groups, dependent: :destroy
  validates :year_of_study, presence: true
  validates :course_id, presence: true
  enum year_of_study: { first_year: 1, second_year: 2, third_year: 3,
                        fourth_year: 4, fifth_year: 5, sixth_year: 6,
                        seventh_year: 7 }

  accepts_nested_attributes_for :groups

  def self.max_year_of_study
    7
  end

  def groups_existent?
    self.groups.count > 0
  end

  def to_s
    "#{year_of_study.titleize}"
  end
end
