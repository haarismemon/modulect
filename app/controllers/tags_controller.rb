class TagsController < ApplicationController

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tags_params)
    # Save the object
    if @tag.save
      # If save succeeds, redirect to the index action
      flash[:notice] = @tag.name+" was created successfully."
      redirect_to(tags_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end
  end

end
