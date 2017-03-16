class AddDefaultsToAppSetting < ActiveRecord::Migration[5.0]
  def change
  	change_column :app_settings, :is_offline, :boolean, :default => false
  	change_column :app_settings, :allow_new_registration, :boolean, :default => true
  end
end
