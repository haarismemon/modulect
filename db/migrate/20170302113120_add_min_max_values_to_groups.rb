class AddMinMaxValuesToGroups < ActiveRecord::Migration[5.0]
  def change  	
    add_column :groups, :min_modules, :integer
    add_column :groups, :max_modules, :integer
    add_column :groups, :min_credits, :integer
    add_column :groups, :max_credits, :integer
  end
end
