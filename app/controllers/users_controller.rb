class UsersController < ApplicationController

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