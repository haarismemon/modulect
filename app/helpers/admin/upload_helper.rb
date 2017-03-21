module Admin::UploadHelper
  def parse_mult_association_string(mult_assoc_string)
    if mult_assoc_string.nil?
      ['']
    else
      mult_assoc_string.gsub('; ', ';').split(';')
    end
  end
end
