class AddUserIdUniModuleIdToSavedModule < ActiveRecord::Migration[5.0]
  def change
  	add_column :saved_modules, :user_id, :integer
  	add_column :saved_modules, :uni_module_id, :integer
  end
end
