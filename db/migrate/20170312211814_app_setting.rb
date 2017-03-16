class AppSetting < ActiveRecord::Migration[5.0]
  def change
    create_table :app_settings do |t|
	  t.integer  :singleton_guard
      t.boolean :is_offline
      t.text :offline_message
      t.boolean :allow_new_registration

      t.timestamps
    end

	add_index(:app_settings, :singleton_guard, :unique => true)
  end
end

