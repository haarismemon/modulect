class CreateJoinTableDepartmentUniModule < ActiveRecord::Migration[5.0]
  def change
    create_join_table :Departments, :UniModules do |t|
      t.index [:department_id, :uni_module_id], name: "index_department_uni_module"
      t.index [:uni_module_id, :department_id], name: "index_uni_module_department"
    end
  end
end
