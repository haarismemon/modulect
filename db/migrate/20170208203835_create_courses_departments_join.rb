class CreateCoursesDepartmentsJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :courses_departments, :id => false do |t|
      t.integer "course_id"
      t.integer "department_id"
    end

    add_index("courses_departments", ["course_id", "department_id"])
  end
end
