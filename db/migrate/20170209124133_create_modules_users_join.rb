class CreateModulesUsersJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :modules_users, :id => false do |t|
      t.integer "uni_module__id"
      t.integer "user_id"
    end

    add_index("modules_users", ["uni_module__id", "user_id"])
  end
end
