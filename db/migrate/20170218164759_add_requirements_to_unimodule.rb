class AddRequirementsToUnimodule < ActiveRecord::Migration[5.0]
  def change
    add_column :uni_modules, :requirements, :string
    remove_column :uni_modules, :requirements_id, :integer
  end
end
