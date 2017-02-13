class AddMoreInfoAndCompulsoryToModules < ActiveRecord::Migration[5.0]
  def change
    add_column :uni_modules, :more_info_url, :string
    add_column :uni_modules, :compulsory, :boolean, default: false
  end
end
