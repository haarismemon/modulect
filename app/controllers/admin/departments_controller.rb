module Admin
  class DepartmentsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Department.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Department.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    before_action :make_data_store_nil, only: [:index,:show]
    def create
      resource = resource_class.new(resource_params)
      if resource.save
        session_for_adding = session[:data_save]
        if !session_for_adding.nil? && session_for_adding["from_form"]
          locate_redirect_back(session_for_adding,resource)
        else
          redirect_to(
              [namespace, resource],
              notice: translate_with_resource("create.success"),
          )
        end
      else
        render :new, locals: {
            page: Administrate::Page::Form.new(dashboard, resource),
        }
      end
    end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    private
    def locate_redirect_back(store,resource)
      if (store["isEdit"])

        redirect_to(edit_admin_faculty_path(id: store["faculty"]["id"]),
                    notice:"#{resource.name} has been added")
      else
        redirect_to(new_admin_faculty_path,
                    notice:"#{resource.name} has been added")
        session[:data_save] = nil
      end
    end


  end
end
