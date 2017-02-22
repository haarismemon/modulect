class AddMoreInfoLinkToUniModule < ActiveRecord::Migration[5.0]
  def change
    add_column :uni_modules, :more_info_link, :string
  end
end
