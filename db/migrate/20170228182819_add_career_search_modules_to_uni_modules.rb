class AddCareerSearchModulesToUniModules < ActiveRecord::Migration[5.0]
  def change
    add_column :uni_modules, :career_search_modules, :string
  end
end
