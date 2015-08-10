class FbpostsController < ApplicationController
  before_action :set_fbpost, only: [:show, :update, :destroy]

  # GET /fbposts
  # GET /fbposts.json
  def index
    @fbposts = Fbpost.all

    render json: @fbposts
  end

  # GET /fbposts/1
  # GET /fbposts/1.json
  def show
    render json: @fbpost
  end

  # POST /fbposts
  # POST /fbposts.json
  def create
    @fbpost = Fbpost.new(fbpost_params)

    @fbpost.save

    if @fbpost.likes_data
      likes = string_to_json(@fbpost.likes_data)
      likes.each do |like|
        @fbpost.fblikes.create(fblikes_params(like, @fbpost.fb_user_token))
      end
    end

    if @fbpost.save
      render json: @fbpost, status: :created, location: @fbpost
    else
      render json: @fbpost.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def update
    @fbpost = Fbpost.find(params[:id])

    if @fbpost.update(fbpost_params)
      head :no_content
    else
      render json: @fbpost.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fbposts/1
  # DELETE /fbposts/1.json
  def destroy
    @fbpost.destroy

    head :no_content
  end

  private
    def string_to_json(this_string)
      JSON.parse this_string.gsub('=>', ':')
    end

    def set_fbpost
      @fbpost = Fbpost.find(params[:id])
    end

    def fbpost_params
      params.require(:fbpost).permit(:story, :message, :likes, :likes_data, :integer, :url, :date, :user_token, :fb_user_token)
    end

    def fblikes_params(like, fb_user_token)
      gender = get_gender(fb_user_token, like['id'])

      return {
        user_facebook_id: like['id'],
        user_name: like['name'],
        gender: gender
      }
    end

    def get_gender(fb_user_token, friend)
      auth_user = Koala::Facebook::API.new(fb_user_token)
      name = auth_user.get_object(friend + '?fields=first_name')
      gender = Guess.gender(name["first_name"])[:gender]
    end
end
