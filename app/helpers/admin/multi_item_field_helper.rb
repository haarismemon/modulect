module Admin::MultiItemFieldHelper
  MULTI_ITEM_FIELD_SEPARATOR = ';'

  def split_multi_association_field(mult_assoc_string)
    if mult_assoc_string.nil?
      []
    else
      mult_assoc_string.gsub('; ', ';').split(';')
    end
  end
end