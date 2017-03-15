class SavedModule < ApplicationRecord
	belongs_to :user
	belongs_to :uni_module
end
