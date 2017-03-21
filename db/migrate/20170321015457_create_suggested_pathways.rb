class CreateSuggestedPathways < ActiveRecord::Migration[5.0]
  def change
    create_table :suggested_pathways do |t|
		t.string   "name"
	    t.string   "data"                 
	    t.integer  "year"
	    t.integer  "course_id"
      t.timestamps
    end
  end
end
