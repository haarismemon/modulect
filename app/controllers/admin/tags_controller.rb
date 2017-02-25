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

    def create
      @tag = Tag.create(name: params[:tag_name], type: params[:tag_type])

      if @tag.save
        redirect_to(admin_uni_modules_path)
      else
        redirect_to(new_admin_tag_path)
        flash[:notice] = "Tag creation failed. Parameters passed: [name: #{params[:tag_name]}, type: #{params[:tag_type]}]"
      end
    end

  end
end
