module ApplicationHelper

	# A simple helper method which sets the page title
	def full_title(page_title = '')
	    base_title = "Modulect"
	    if page_title.empty?
	      base_title
	    else
	      page_title + " | " + base_title
	    end
	end


	def get_careers_for_module(valid_uni_module)
	    @careers = []
	    valid_uni_module.career_tags.each do |careertag|
	      @careers.push(careertag.name)
	    end
	    @careers
	end

end
