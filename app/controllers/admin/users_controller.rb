module Admin
  class UsersController < ApplicationController

    def new
      @user = User.new
    end


  end
end