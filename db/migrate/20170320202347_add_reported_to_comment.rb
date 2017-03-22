class AddReportedToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :reported, :boolean, default: false
  end
end
