class ChangeModuleIdToUniModuleIdinUniModuleLog < ActiveRecord::Migration[5.0]
  def change
    remove_column :uni_module_logs, :module_id
    add_column :uni_module_logs, :uni_module_id, :integer
  end
end
