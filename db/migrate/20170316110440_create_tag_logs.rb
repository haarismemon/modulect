class CreateTagLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :tag_logs do |t|
      t.integer "tag_id"
      t.integer "counter"
      t.integer "department_id"

      t.timestamps
    end
  end
end
