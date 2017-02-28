class RemoveCompulsoryFromUniModulesAndAddCompulsoryToGroupUniModules < ActiveRecord::Migration[5.0]
  def change
  	remove_column :uni_modules , :compulsory
  	add_column :groups_uni_modules, :compulsory, :boolean
  end
end
