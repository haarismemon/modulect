require "administrate/field/base"

class YearOfStudyField < Administrate::Field::Base
  def to_s
    data
  end
end
