class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :uni_module_id

      t.timestamps
    end
    add_index :taggings, :tag_id
    add_index :taggings, :uni_module_id
    add_index :taggings, [:tag_id, :uni_module_id]
  end
end
