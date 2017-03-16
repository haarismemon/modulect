class Group < ApplicationRecord

  belongs_to :year_structure, dependent: :destroy
  has_and_belongs_to_many :uni_modules
  validates :name, presence: true
  validates :max_credits, presence: true
  validates :min_credits, presence: true
  validate 'min_can_not_be_bigger_than_max'

  scope :search_by_module, lambda {|module_code|
    joins(:uni_modules).where(["uni_modules.code = ?", module_code])
  }

  # validation to check maxiumum credits is not smaller than minimum
  def min_can_not_be_bigger_than_max
    if !max_credits.nil? && !min_credits.nil? && min_credits.to_int > max_credits.to_int
      errors.add(:minimum_credits, "can't be greater than maximum credits")
    end
  end

end
