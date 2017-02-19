class YearStructure < ApplicationRecord
  belongs_to :course, optional: true
  has_many :groups
  validates :year_of_study, presence: true
  enum year_of_study: { first_year: 1, second_year: 2, third_year: 3,
                        fourth_year: 4, fifth_year: 5, sixth_year: 6,
                        seventh_year: 7 }
end
