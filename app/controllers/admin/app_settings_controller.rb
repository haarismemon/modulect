module Admin
  class AppSettingsController < Admin::BaseController
      
      def edit
        @app_setting = app_settings
      end

      def update
        # Find a  object using id parameters
        @app_setting = app_settings
        if @app_setting.update_attributes(app_setting_params)
          # If save succeeds, redirect to the index action
          flash[:success] = "Successfully updated "
          redirect_to(edit_admin_app_setting_path) and return
        else
          # If save fails, redisplay the form so user can fix problems
          render('admin/app_settings/edit')
        end
      end

      private 
      def app_setting_params
        params.require(:app_setting).permit(:is_offline, :offline_message, :allow_new_registration)
      end

  end
end
