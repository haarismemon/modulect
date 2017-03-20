class CreateNotices < ActiveRecord::Migration[5.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.integer :department_id
      t.string :notice_body
      t.date  :live_date
      t.date  :end_date
      t.string :optional_link
      t.boolean :broadcast
      t.boolean :auto_delete
      t.timestamps
    end
  end
end
