class FbcommentsController < ApplicationController

  before_action :set_fbcomment, only: [:update, :destroy]

  # GET /fbcomments
  # GET /fbcomments.json
  def index

    @fbcomments = Fbcomment.all
    render json: @fbcomments

  end

  # since=one%20month%20ago
  def show
      if params[:since]
        sinceDate = Chronic.parse(params[:since])
        @fbcomments = Fbcomment.where("date > ? and bpopToken == ?", sinceDate, params[:id])
      else
        @fbcomments = Fbcomment.where(bpopToken: params[:id])
      end
      render json: {count: @fbcomments.length, likes: @fbcomments}
    end




  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def update
    @fbcomment = Fbcomment.find(params[:id])

    if @fbcomment.update(fbcomment_params) #private section#
      head :no_content
    else
      render json: @fbcomment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fbposts/1
  # DELETE /fbposts/1.json
  def destroy
    @fbcomment.destroy

    head :no_content
  end

  private

  def fbcomments_params
    params.require(:fbcomment).permit(:user_facebook_id, :user_name, :gender, :bpopToken, :date)
  end


  def set_fbcomment
    @fbcomment = Fbcomment.find(params[:id])
  end

end