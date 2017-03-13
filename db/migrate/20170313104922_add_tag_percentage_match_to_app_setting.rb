class AddTagPercentageMatchToAppSetting < ActiveRecord::Migration[5.0]
  def change
  	add_column :app_settings, :tag_percentage_match, :decimal, :default => 60.0
  end
end
