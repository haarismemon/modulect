require 'json'

class Pathway < ApplicationRecord

  validates :data, presence: true

  # A pathway belongs to one user
  belongs_to :user, optional: true

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
