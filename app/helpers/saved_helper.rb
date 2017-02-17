module SavedHelper


	# returns an array of results sorted according to the sort by category
  # inputs are the array of unsorted results, and a string of the category to sort by
  # written by Haaris
	def sort_by(results_array, sort_by_category)
    if(results_array.is_a?(Array))
      results_array = Array(results_array)
    end

    if results_array.empty? || sort_by_category == ""
      return results_array
    end

    modules_with_weightings = []
    modules_with_no_weightings = []
    modules_with_pass_rate = []
    modules_with_no_pass_rate = []

    results_array.each do |result|
      uni_module = result[0]
      # if module has exam + coursework percentage that are not nil, then store in array for weightings
      if uni_module.exam_percentage && uni_module.coursework_percentage
        modules_with_weightings << result
      else
        modules_with_no_weightings << result
      end

      # if module has pass rate that is not nil, then store in array for pass rate
      if uni_module.pass_rate
        modules_with_pass_rate << result
      else
        modules_with_no_pass_rate << result
      end
    end

    if sort_by_category == "coursework"
      # sorted results according to coursework percentage
      results_with_attribute = modules_with_weightings.sort_by { |result| [result[0].coursework_percentage, result[1].size] }
      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}
      return (results_without_attribute.concat results_with_attribute).reverse
    elsif sort_by_category == "exam"
      # sorted results according to exam percentage
      results_with_attribute = modules_with_weightings.sort_by { |result| [result[0].exam_percentage, result[1].size] }
      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}
      return (results_without_attribute.concat results_with_attribute).reverse
    elsif sort_by_category == "pass"
      # sorted results according to pass rate
      results_with_attribute = modules_with_pass_rate.sort_by { |result| [result[0].pass_rate, result[1].size] }
      # sort the remaining modules (without the pass rate attribute) according to number of tags matched
      results_without_attribute = modules_with_no_pass_rate.sort_by {|result| result[1].size}
      return (results_without_attribute.concat results_with_attribute).reverse
    end

    return results_array

  end



  # converts an input array into a results type (Haaris')
  # written by Aqib
  def convert_to_results_array(input)
    results = {}
    input.each do |unimodule|
      results[unimodule] = []
    end
	results
  end


end