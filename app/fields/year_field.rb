require "administrate/field/base"

class YearField < Administrate::Field::Base
  def to_s
    data
  end
end
