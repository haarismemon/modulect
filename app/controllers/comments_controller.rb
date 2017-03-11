class CommentsController < ApplicationController

  def create
    @uni_module = UniModule.find(params[:uni_module_id])

    @comment = @uni_module.comments.create(comment_params)

    redirect_to uni_module_path(@uni_module)
  end

end
