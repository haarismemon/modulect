class CreatePathways < ActiveRecord::Migration[5.0]
  def change
    create_table :pathways do |t|
      t.string :name, default: "Pathway"
      t.string :data
      t.integer :user_id

      t.timestamps
    end
  end
end
