class FblikesController < ApplicationController

  before_action :set_fblike, only: [:update, :destroy]

  # GET /fblikes
  # GET /fblikes.json
  def index
    if params[:limit]
      @fblikes = Fblike.all.first(params[:limit].to_i)
    else
      @fblikes = Fblike.all
   end
    render json: @fblikes
  end


  # since=one+month+ago
  def show
      if params[:since]
        sinceDate = Chronic.parse(params[:since])
        if params[:limit]
          @fblikes = Fblike.where("date > ? and bpopToken == ?", sinceDate, params[:id]).first(params[:limit].to_i)
        else
          @fblikes = Fblike.where("date > ? and bpopToken == ?", sinceDate, params[:id])
        end
      else
        if params[:limit]
          @fblikes = Fblike.where(bpopToken: params[:id]).first(params[:limit])
        else
          @fblikes = Fblike.where(bpopToken: params[:id])
        end
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
