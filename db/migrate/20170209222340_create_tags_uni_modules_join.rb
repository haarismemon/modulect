class CreateTagsUniModulesJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :tags_uni_modules, :id => false do |t|
      t.integer "tag_id"
      t.integer "uni_module_id"
    end

    add_index("tags_uni_modules", ["tag_id", "uni_module_id"])
  end
end
