class FblikesController < ApplicationController

  before_action :set_fblike, only: [:update, :destroy]

  # GET /fblikes
  # GET /fblikes.json
  def index

    @fblikes = Fblike.all
    render json: @fblikes

  end

  # since=one%20month%20ago
  def show
      if params[:since]
        sinceDate = Chronic.parse(params[:since])
        @fblikes = Fblike.where("date > ? and bpopToken == ?", sinceDate, params[:id])
      else
        @fblikes = Fblike.where(bpopToken: params[:id])
      end
      render json: {count: @fblikes.length, likes: @fblikes}
    end




  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def update
    @fblike = Fblike.find(params[:id])

    if @fblike.update(fblike_params) #private section#
      head :no_content
    else
      render json: @fblike.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fbposts/1
  # DELETE /fbposts/1.json
  def destroy
    @fblike.destroy

    head :no_content
  end

  private

  def fblikes_params
    params.require(:fblike).permit(:user_facebook_id, :user_name, :gender, :bpopToken, :date)
  end


  def set_fblike
    @fblike = Fblike.find(params[:id])
  end

end
