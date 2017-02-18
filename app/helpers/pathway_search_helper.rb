module PathwaySearchHelper

	def exists_next_year_for(course_id, current_year)
		if !YearStructure.where("course_id = ? AND year_of_study = ?", course_id, ++current_year).empty?
			true
		else
			false
		end
	end
end
