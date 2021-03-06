class FbcommentsController < ApplicationController

  before_action :set_fbcomment, only: [:update, :destroy]

  # GET /fbcomments
  # GET /fbcomments.json
  def index
    if params[:limit]
      @fbcomments = Fbcomment.all.first(params[:limit].to_i)
    else
      @fbcomments = Fbcomment.all
   end
    render json: @fbcomments
  end

  # since=one+month+ago
  def show
      if params[:since]
        sinceDate = Chronic.parse(params[:since])
        if params[:limit]
          @fbcomments = Fbcomment.where("date > ? and bpoptoken = ?", sinceDate, params[:id]).first(params[:limit].to_i)
        else
          @fbcomments = Fbcomment.where("date > ? and bpoptoken = ?", sinceDate, params[:id])
        end
      else
        if params[:limit]
          @fbcomments = Fbcomment.where(bpoptoken: params[:id]).first(params[:limit])
        else
          @fbcomments = Fbcomment.where(bpoptoken: params[:id])
        end
      end
      # render json: {count: @fbcomments.length, comments: @fbcomments} PREVIOUS VERSION
      render :json => @fbcomments, :except=>  [:bpoptoken, :fbpost_id, :user_facebook_id]
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
    params.require(:fbcomment).permit(:user_name, :message, :fbpost_id, :gender, :date, :user_facebook_id, :bpoptoken)
  end


  def set_fbcomment
    @fbcomment = Fbcomment.find(params[:id])
  end

end
