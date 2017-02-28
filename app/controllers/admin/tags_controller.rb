module Admin
  class TagsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # simply overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Tag.all.paginate(10, params[:page])
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Tag.find_by!(slug: param)
    # end

    # See https://administrate-docs.herokuapp.com/customizing_controller_actions
    # for more information

    def add_new_tag
      @tag = Tag.create(name: params[:tag_name], type: params[:tag_type])
      @uni_module = UniModule.find(params[:uni_module_id])

      @uni_module.tags << @tag
    end

  end
end
