class SavedModule < ApplicationRecord
	belongs_to :user, :foreign_key => :user_id
	belongs_to :uni_module, :foreign_key => :uni_module_id
end
