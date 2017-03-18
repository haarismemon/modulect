class AddReviewSettingsToAdmin < ActiveRecord::Migration[5.0]
  def change
  	add_column :app_settings, :disable_new_reviews, :boolean, :default => false
  	add_column :app_settings, :disable_all_reviews, :boolean, :default => false
  end
end
