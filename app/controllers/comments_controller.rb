class CommentsController < ApplicationController

  def create
    @uni_module = UniModule.find(params[:uni_module_id])

    @user = User.find(current_user.id)
    @user_comments = Array(@user.comments).keep_if { |c| String(c.uni_module.id) == params[:uni_module_id] }

    if @user_comments.length < 1
      @comment = @uni_module.comments.create(comment_params)

      @updated_comments = @uni_module.comments.order("created_at DESC")

      respond_to do |format|
        format.js { render 'update_comments.js.erb' }
      end
    else
      head :no_content
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

  def edit
    edited_text = params[:edited_text]
    comment_id = params[:comment_id]
    new_rating_val = params[:new_rating_val]
    @comment = Comment.find(comment_id.to_i)
    @comment.update_attributes(body: edited_text, rating: new_rating_val)
    @uni_module = UniModule.find(@comment.uni_module_id)
    @updated_comments = @uni_module.comments.order("created_at DESC")

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

  def delete
    Comment.delete(params[:comment_id])

    @uni_module = UniModule.find(params[:uni_module_id])

    user_reviews_count = (Comment.all.where user_id: current_user.id).length

    type_delete = params[:type_delete].to_s
    if type_delete.eql? "module_page"
      @updated_comments = @uni_module.comments.order("created_at DESC")
      respond_to do |format|
        format.js { render 'update_comments.js.erb' }
      end
    elsif type_delete.eql? "review_page"
      data = {user_reviews_count: user_reviews_count}
      render json: data
    else
      head :no_content
    end


  end

  def destroy
    comment = Comment.find(params[:id]).destroy
    redirect_to admin_comment_path(comment.uni_module)
  end

  def report
    @comment = Comment.find(params[:comment_id])

    if @comment.reported
      @comment.update_attributes(reported: false)
      reported = false
    else
      @comment.update_attributes(reported: true)
      reported = true
    end

    data = {reported: reported}
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
