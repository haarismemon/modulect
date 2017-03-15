class AddDeptIdToVisitorLog < ActiveRecord::Migration[5.0]
  def change
  	add_column :visitor_logs, :department_id, :integer
  end
end
