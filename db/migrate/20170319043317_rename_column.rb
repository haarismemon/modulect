class RenameColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :notices, :title, :header
  end
end
