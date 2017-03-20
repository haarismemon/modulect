class CreatePathwaySearchLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :pathway_search_logs do |t|
    	t.integer "first_mod_id"
      t.integer "second_mod_id"
      t.integer "counter"
      t.integer "department_id"
      t.integer "course_id"
      t.timestamps
    end
  end
end
