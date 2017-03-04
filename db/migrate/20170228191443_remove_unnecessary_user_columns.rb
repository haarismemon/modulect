class RemoveUnnecessaryUserColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :career_search_modules, :string
  end
end
