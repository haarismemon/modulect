class RenameModulesUsersToUniModulesUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :modules_users, :uni_modules_users
  end
end
