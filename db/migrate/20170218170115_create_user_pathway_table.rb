class CreateUserPathwayTable < ActiveRecord::Migration[5.0]
  def change
    create_table :user_pathways do |t|
      t.integer "user_id"
      t.string "saved_name"
      t.string "saved_pathway"
    end

    add_index "user_pathways", "user_id"
  end
end
