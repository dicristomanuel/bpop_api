class UsersController < ApplicationController

  def create_user
    @user = User.first_or_create(bpoptoken: params['fbpost']['bpoptoken'])
    render json: @user
  end

  def is_complete
    user = User.where(bpoptoken: params[:bpoptoken])
    @is_complete = user.first.is_parsing_complete
    render json: @is_complete
  end

  def is_complete_to_false
    user = User.where(bpoptoken: params[:bpoptoken])
    user.update_all(is_parsing_complete: false)
    render json: @is_complete
  end

end
