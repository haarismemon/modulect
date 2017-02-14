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

  def update
    # Find a new object using form parameters
    @tag = Tag.find(params[:id])
    # Update the object
    if @tag.update_attributes(tags_params)
      # If save succeeds, redirect to the show action
      flash[:notice] = @tag.name+" was updated successfully."
      redirect_to(tag_path(@tag))
    else
      # If save fails, redisplay the form so user can fix problems
      render('edit')
    end
  end

  def edit
    #! looks for object to ready populate form with the associated tag's data ready for modification by admin
    @tag = Tag.find(params[:id])
  end

  def destroy
    #find by id
    @tag = Tag.find(params[:id])
    #delete tuple object from db
    @tag.destroy
    flash[:notice] =  @tag.name+"was deleted successfully."
    #redirect to action which displays all tags
    redirect_to(tags_path)
  end

  def index
    #returns all tags by order of tag name
    @tags = Tag.alphabetically_order_by("name")
  end

  def show
    @tag = Tag.find(params[:id])
  end

end
