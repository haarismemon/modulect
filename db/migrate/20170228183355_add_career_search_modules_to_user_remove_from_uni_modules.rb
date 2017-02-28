class AddCareerSearchModulesToUserRemoveFromUniModules < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :career_search_modules, :string
    remove_column :uni_modules, :career_search_modules, :string
  end
end
