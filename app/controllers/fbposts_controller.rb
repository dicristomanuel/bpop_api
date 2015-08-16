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
    #creating new fbpost
    @fbpost = Fbpost.new(fbpost_params) #private section#
    if @fbpost.save
    #if fbpost has comments get the string and parse it to JSON, for each like create new fblike
    if @fbpost.likes_data != '0'
      likes = string_to_json(@fbpost.likes_data) #private section#
      likes.each do |like|
        @fbpost.fblikes.create(fblikes_params(like, @fbpost.fb_user_token)) #private section#
      end
      likesGenderPercentage = calculate_gender_percentage_likes(@fbpost.fblikes)
      @fbpost.update(
        likesGenderPercentage: likesGenderPercentage
       ) #private section#
    end

    if @fbpost.comments_data != '0'
      comments = string_to_json(@fbpost.comments_data) #private section#
      comments.each do |comment|
        @fbpost.fbcomments.create(fbcomments_params(comment, @fbpost.fb_user_token)) #private section#
      end
      commentsGenderPercentage = calculate_gender_percentage_comments(@fbpost.fbcomments)
      @fbpost.update(
        commentsGenderPercentage: commentsGenderPercentage
       ) #private section#
    end

      render json: @fbpost, status: :created, location: @fbpost
    else
      render json: @fbpost.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def update
    @fbpost = Fbpost.find(params[:id])

    if @fbpost.update(fbpost_params) #private section#
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


  def get_overall_gender_percentage
    #get user's token to identify the user
    @result = Fbpost.where(bpopToken:params['bpopToken'])
    render json: @result
  end



  private

    def string_to_json(this_string)
      JSON.parse this_string.gsub('=>', ':')
    end


    def set_fbpost
      @fbpost = Fbpost.find(params[:id])
    end


    def fbpost_params
      params.require(:fbpost).permit(:story, :message, :likes, :likes_data, :comments_data, :integer, :url, :date, :bpopToken, :fb_user_token)
    end


    def fblikes_params(like, fb_user_token)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, like['id'])
      return {
        user_facebook_id: like['id'],
        user_name: like['name'],
        gender: gender
      }
    end

    def fbcomments_params(comment, fb_user_token)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, comment['from']['id'])
      return {
        fbuser_id: comment['from']['id'],
        user_name: comment['from']['name'],
        message: comment['message'],
        gender: gender
      }
    end


    def get_gender(fb_user_token, friend)
      #exchange fb token for access
      auth_user = Koala::Facebook::API.new(fb_user_token)
      #get the name of the single user
      name = auth_user.get_object(friend + '?fields=first_name')
      #find the gender of the users their first name trough gem-guess
      gender = Guess.gender(name["first_name"])[:gender]
    end


    def calculate_gender_percentage_likes(likes)
      #intialize empty hash
      genders = Hash.new 0
      #for each gender type add one to the count
      likes.each do |gender|
        unless gender.gender == "unknown"
          genders[gender.gender] += 1
        end
      end
        #calculate how many likes recieved
        total = genders.values.inject(:+)
        #calculate female percentage
        female_percentage = (100).to_f / (total).to_f * genders["female"].to_f
        #calculate male percentage
        male_percentage = 100 - female_percentage

        if female_percentage == NaN
          female_percentage = 0
        end

        if male_percentage == NaN
          male_percentage = 0
        end

      #store and return data into a hash
      genders_percentage = {male: male_percentage, female: female_percentage}
    end


    def calculate_gender_percentage_comments(comments)
      #intialize empty hash
      genders = Hash.new 0
      #for each gender type add one to the count
      comments.each do |gender|
        unless gender.gender == "unknown"
          genders[gender.gender] += 1
        end
      end
        #calculate how many comments recieved
        total = genders.values.inject(:+)
        #calculate female percentage
        female_percentage = (100).to_f / (total).to_f * genders["female"].to_f
        #calculate male percentage
        male_percentage = 100 - female_percentage

        if female_percentage == NaN
          female_percentage = 0
        end

        if male_percentage == NaN
          male_percentage = 0
        end

      #store and return data into a hash
      genders_percentage = {male: male_percentage, female: female_percentage}
    end

end
