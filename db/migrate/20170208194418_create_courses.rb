class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :code
      t.string :level
      t.string :description

      t.timestamps
    end
  end
end
