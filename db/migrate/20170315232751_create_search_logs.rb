class CreateSearchLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :search_logs do |t|
      t.string "search_type"
      t.integer "counter"
      t.integer "department_id"
      t.timestamps
    end
  end
end
