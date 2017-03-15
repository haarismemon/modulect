class CreateVisitorLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :visitor_logs do |t|
      t.string "session_id"
      t.boolean "logged_in"
      t.string "device_type"
      t.timestamps
    end
  end
end
