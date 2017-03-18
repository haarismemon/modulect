module Admin
  class AppSettingsController < Admin::BaseController
    before_action :verify_super_admin, only: [:destroy, :new, :create, :update, :edit, :index]
      
      def edit
        @app_setting = app_settings
      end

      def update
        # Find a  object using id parameters
        @app_setting = app_settings
        if @app_setting.update_attributes(app_setting_params)
          flash[:success] = "Successfully updated settings"
          redirect_to(admin_settings_path) and return
        else
          flash[:error] = "Something went wrong"
          render('admin/settings')
        end
      end

      private 
      def app_setting_params
        params.require(:app_setting).permit(:is_offline, :offline_message, :allow_new_registration, :tag_percentage_match,:disable_new_reviews, :disable_all_reviews)
      end

       
      def verify_super_admin
       redirect_to admin_path unless current_user.user_level == "super_admin_access"

      end

  end
end
