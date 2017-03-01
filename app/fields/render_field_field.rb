require "administrate/field/base"

class RenderFieldField < Administrate::Field::Base
  def to_s
    data
  end
end
