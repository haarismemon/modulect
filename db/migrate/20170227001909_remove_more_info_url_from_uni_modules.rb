class RemoveMoreInfoUrlFromUniModules < ActiveRecord::Migration[5.0]
  def change
  	remove_column :uni_modules , :more_info_url
  end
end
