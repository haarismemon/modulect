class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username
      t.string :password_digest
      t.integer :user_level
      t.boolean :entered_before
      t.integer :year_of_study
      t.integer :course_id

      t.timestamps
    end
  end
end
