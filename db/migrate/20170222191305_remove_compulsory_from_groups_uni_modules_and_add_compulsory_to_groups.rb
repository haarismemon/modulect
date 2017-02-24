class RemoveCompulsoryFromGroupsUniModulesAndAddCompulsoryToGroups < ActiveRecord::Migration[5.0]
  def change
  	remove_column :groups_uni_modules , :compulsory
  	add_column :groups, :compulsory, :boolean
  end
end
