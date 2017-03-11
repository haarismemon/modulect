class CommentsController < ApplicationController

  def create
    @uni_module = UniModule.find(params[:uni_module_id])

    @comment = @uni_module.comments.create(comment_params)

    @updated_comments = @uni_module.comments.order("created_at DESC").page(params[:page]).per(5)

    respond_to do |format|
      format.js
    end
  end

  private
    def comment_params
      if logged_in?
        params[:comment][:commenter] = current_user.full_name
      end
      params.require(:comment).permit(:commenter, :rating, :body)
    end

end
