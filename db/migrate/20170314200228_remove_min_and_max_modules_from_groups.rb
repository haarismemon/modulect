class RemoveMinAndMaxModulesFromGroups < ActiveRecord::Migration[5.0]
  def change
  	remove_column :groups, :min_modules
  	remove_column :groups, :max_modules
  end
end
