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

end
