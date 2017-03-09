module OldAdmin
  class FacultiesController < OldAdmin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Faculty.all.paginate(10, params[:page])
    # end
    before_action :make_data_store_nil, only: [:index,:show]
    def new
      super
      set_data_session ({"from_form" => "true","isEdit" =>false })
    end

    def edit
      super
      if(session[:data_save].present?&&session[:data_save]["faculty"])
        @_requested_resource = Faculty.new(session[:data_save]["faculty"])
      end
      set_data_session({"from_form" => true, "isEdit" =>true,"faculty" => @_requested_resource})
    end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Faculty.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information
    private
    def set_data_session(value = nil)
      session[:data_save] = value
    end





  end
end
