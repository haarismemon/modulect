class RemoveReportedAttributeFromComment < ActiveRecord::Migration[5.0]
  def change
    remove_column :comments, :reported
  end
end
