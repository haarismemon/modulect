class SuggestedPathway < ApplicationRecord

  validates :data, presence: true
  belongs_to :course, optional: true

  # returns the list of modules from this pathway
	def get_module_list
  	years = JSON.parse data
  	out = []
  	years.each do |year|
  		year.each do |group|
  			group.each do |module_id|
  				out.push UniModule.find_by_id(module_id)
  			end
  		end
  	end
  	out
  end	

end
