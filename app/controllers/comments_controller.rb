class CommentsController < ApplicationController

  def create
    @uni_module = UniModule.find(params[:uni_module_id])

    @comment = @uni_module.comments.create(comment_params)

    @updated_comments = @uni_module.comments.order("created_at DESC")

    respond_to do |format|
      format.js { render 'update_comments.js.erb' }
    end
  end

  def sort
    @uni_module = UniModule.find(params[:uni_module_id])

    sort_by_type = params[:sort_by_type]

    if sort_by_type.eql? 'created_at'
      @updated_comments = @uni_module.comments.order("created_at DESC")
    elsif sort_by_type.eql? 'rating'
      @updated_comments = @uni_module.comments.order("rating DESC")
    end

    respond_to do |format|
      format.js { render 'update_comments.js.erb' }
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
