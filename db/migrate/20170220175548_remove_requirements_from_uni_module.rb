class RemoveRequirementsFromUniModule < ActiveRecord::Migration[5.0]
  def change
  	remove_column :uni_modules , :requirements
  end
end
