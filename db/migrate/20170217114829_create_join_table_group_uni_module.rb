class CreateJoinTableGroupUniModule < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Groups, :UniModules do |t|
      t.index [:group_id, :uni_module_id]
      t.index [:uni_module_id, :group_id]
    end
  end
end
