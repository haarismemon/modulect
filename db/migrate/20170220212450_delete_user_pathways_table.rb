class DeleteUserPathwaysTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_pathways
  end
end
