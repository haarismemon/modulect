class Group < ApplicationRecord
  
  belongs_to :year_structure, optional: true
  has_and_belongs_to_many :uni_modules
  validates :name, presence: true
  validates :total_credits, presence: true

  scope :search_by_module, lambda {|module_name|
    joins(:uni_modules).where(["uni_modules.name = ?", module_name])
  }

end
