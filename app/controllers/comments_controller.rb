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

  def like
    @comment = Comment.find(params[:comment_id])
    @user = User.find(current_user.id)

    if @comment.liked_users.include? @user
      @comment.liked_users.delete @user
      helpful = false
    else
      @comment.liked_users << @user
      helpful = true
    end

    data = {like_count: @comment.liked_users.length, helpful: helpful}
    render json: data

  end

  private
    def comment_params
      if logged_in?
        params[:comment][:user_id] = current_user.id
      end
      params.require(:comment).permit(:user_id, :rating, :body)
    end

end
