class Group < ApplicationRecord

  belongs_to :year_structure, dependent: :destroy
  has_and_belongs_to_many :uni_modules
  validates :name, presence: true
  validates :total_credits, presence: true

  scope :search_by_module, lambda {|module_code|
    joins(:uni_modules).where(["uni_modules.code = ?", module_code])
  }

  def possible_uni_modules
    to_return = []

    self.year_structure.course.departments.each do |department|
      department.uni_modules.each do |uni_module|
        to_return << uni_module if !to_return.include?(uni_module)
      end
    end
    to_return
  end
end
