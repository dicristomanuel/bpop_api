class FbpostsController < ApplicationController
  before_action :set_fbpost, only: [:update, :destroy]
  before_action :set_user, only: [:update]

  # GET /fbposts
  # GET /fbposts.json
  def index
    @fbposts = Fbpost.all
    render json: @fbposts
  end


  # query option: since=one+month+ago
  def show
    if params[:since]
      sinceDate = Chronic.parse(params[:since])
      @fbposts = Fbpost.where("date > ? and bpopToken == ?", sinceDate, params[:id])
    else
      @fbposts = Fbpost.where(bpopToken: params[:id])
    end
    render json: @fbposts
  end



  def create
    @user = User.first_or_create(bpopToken: params['fbpost']['bpopToken'])
    #creating new fbpost
    @fbpost = @user.fbposts.create(fbpost_params) #private section#
      if @fbpost.save
        #follow the logic to create post's likes
        handle_likes(@fbpost)
        #follow the logic to create post's comments
        handle_comments(@fbpost)
        #return @fbpost
        render json: @fbpost, status: :created, location: @fbpost
      else
        render json: @fbpost.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def update

  if @fbpost = Fbpost.find_by_fb_post_id(params[:fbpost][:fb_post_id])
      @fbpost.update_attributes(fbpost_params)
        if @fbpost.changed?
          #follow the logic to create post's likes
          handle_likes(@fbpost)
          #follow the logic to create post's comments
          handle_comments(@fbpost)
        end
  if @fbpost[:is_last] == 'false'
    method = 'post'
    posts_id_container(@user, method)
  else
      to_delete = @user.tempPostsIdContainer - @user.fbposts | @user.fbposts - @user.tempPostsIdContainer
      @user.fbposts.each do |post|
        unless @user.tempPostsIdContainer.include?(post[:fb_post_id])

          Fbpost.where(fb_post_id: post[:fb_post_id]).destroy_all
        end
      end


        method = 'delete'
      posts_id_container(@user, method)
    to_delete = []
    end
  else
    @user.fbposts.create(fbpost_params)
    @fbpost = Fbpost.find_by_fb_post_id(:fb_post_id)
    #follow the logic to create post's likes
    handle_likes(@fbpost)
    #follow the logic to create post's comments
    handle_comments(@fbpost)
  end
  end

  # DELETE /fbposts/1
  # DELETE /fbposts/1.json
  def destroy
    @fbpost.destroy
      head :no_content
  end


  def get_overall_gender_percentage
    #get user's token to identify the user who's requesting the data
    user_posts = Fbpost.where(bpopToken:params['bpopToken'])
      #get percentages for likes and comments
      likes_percentage = get_overall_gender_percentage_likes(user_posts)
      comments_percentage = get_overall_gender_percentage_comments(user_posts)
    #combine percentages to return the final percentage
    render json: final_gender_percentage(likes_percentage, comments_percentage)

  end



  private

    def posts_id_container(user, method)
      if method == 'delete'
        user.tempPostsIdContainer.clear
      else
        user.tempPostsIdContainer << params['fbpost']['fb_post_id']
      end
      user.tempPostsIdContainer_will_change!
      user.save!
    end

    def string_to_json(this_string)
      JSON.parse this_string.gsub('=>', ':')
    end

    def set_fbpost
      @fbpost = Fbpost.find_by(fb_post_id: params[:id])
    end

    def set_user
      @user = User.find_by(bpopToken: params[:fbpost][:bpopToken])
    end


    def fbpost_params
      params.require(:fbpost).permit(
          :owner,
          :story,
          :message,
          :picture,
          :likes,
          :comments,
          :likes_data,
          :comments_data,
          :url,
          :date,
          :bpopToken,
          :fb_user_token,
          :fb_post_id,
          :is_last
        )
    end


    def fblikes_params(like, fb_user_token, bpopToken, date)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, like['id'])
      return {
        user_facebook_id: like['id'],
        user_name: like['name'],
        gender: gender,
        bpopToken: bpopToken,
        date: date
      }
    end

    def fbcomments_params(comment, fb_user_token, bpopToken, date)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, comment['from']['id'])
      return {
        fbuser_id: comment['from']['id'],
        user_name: comment['from']['name'],
        message: comment['message'],
        gender: gender,
        bpopToken: bpopToken,
        date: date
      }
    end


    def get_gender(fb_user_token, friend)
      #exchange fb token for access
      auth_user = Koala::Facebook::API.new(fb_user_token)
      #get the name of the single user
      fbFriend = auth_user.get_object(friend + '?fields=first_name')
      # --- gem guess for genders --- #
      gender = Guess.gender(fbFriend["first_name"])[:gender]
      # --- --- --- --- --- --- --- --- #


      # --- genderize.io for genders --- # more accurate but slower and not free
      # request = Typhoeus::Request.new(
      #   "https://api.genderize.io/?name=" + fbFriend["first_name"],
      #   :headers => {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.130 Safari/537.36"}
      # ).run
      #
      # JSON.parse(request.response_body)['gender']
      # --- --- --- --- --- --- --- --- #

    end


    def handle_likes(fbpost)
      #if fbpost has likes get the string and parse it to JSON, for each like create new fblike
      unless fbpost.likes_data == '0'
        likes = string_to_json(fbpost.likes_data) #private section#
        likes.each do |like|
          fbpost.fblikes.create(fblikes_params(like, fbpost.fb_user_token, fbpost.bpopToken, fbpost.date)) #private section#
        end
        likesGenderPercentage = calculate_gender_percentage_likes(fbpost.fblikes)
        fbpost.update(
          likesGenderPercentage: likesGenderPercentage
         ) #private section#
      end
    end


    def handle_comments(fbpost)
      #if fbpost has comments get the string and parse it to JSON, for each comment create new fbcomment
      unless fbpost.comments_data == '0'
        comments = string_to_json(fbpost.comments_data) #private section#
        comments.each do |comment|
          #check if the user who made the comment already made a comment for the same post (grabbing unique comments only)

          #if fbcomments array is empty and the comment doesn't come from the owner, create the new comment
          if fbpost.fbcomments.empty? && comment['from']['name'] != fbpost.owner
            fbpost.fbcomments.create(fbcomments_params(comment, fbpost.fb_user_token, fbpost.bpopToken, fbpost.date)) #private section#
          #if fbcomments array is not empty and the comment doesn't come from the owner
          elsif comment['from']['name'] != fbpost.owner
            #if not empty check if the user already made a comment
            present = fbpost.fbcomments.any? {|existingComment| existingComment['user_name'].include?(comment['from']['name'])}
            #create comment if user hasn't commented yet on the same post
            unless present
                fbpost.fbcomments.create(fbcomments_params(comment, fbpost.fb_user_token, fbpost.bpopToken, fbpost.date)) #private section#
            end
          end
        end
        commentsGenderPercentage = calculate_gender_percentage_comments(fbpost.fbcomments)
        fbpost.update(
          commentsGenderPercentage: commentsGenderPercentage
         ) #private section#
      end
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

      if genders.empty?
        return {male: 0, female: 0}
      else
        #calculate how many likes recieved
        total = genders.values.inject(:+)
        #calculate female percentage
          female_percentage = (100).to_f / (total).to_f * genders["female"].to_f || 0
        #calculate male percentage
          male_percentage = 100 - female_percentage || 0
        #store and return data into a hash
        {male: male_percentage, female: female_percentage}
      end
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

      if genders.empty?
        return {male: 0, female: 0}
      else
        #calculate how many comments recieved
        total = genders.values.inject(:+)
        #calculate female percentage
        female_percentage = (100).to_f / (total).to_f * genders["female"].to_f || 0
        #calculate male percentage
        male_percentage = 100 - female_percentage || 0
        #store and return data into a hash
        {male: male_percentage, female: female_percentage}
      end
    end

    def get_overall_gender_percentage_likes(user_posts)
      #intialize empty hash
      genders = Hash.new 0
      #for each gender type add one to the count
      user_posts.each do |post|
        post.likesGenderPercentage.each do |key, value|
          genders[key] += value
        end
      end
        #calculate how many likes recieved
        total = genders.values.inject(:+)
        #calculate female percentage
          female_percentage = (100).to_f / (total).to_f * genders[:female].to_f || 0
        #calculate male percentage
          male_percentage = 100 - female_percentage || 0
        #store and return data into a hash
        {male: male_percentage, female: female_percentage}
    end


    def get_overall_gender_percentage_comments(user_posts)
      #intialize empty hash
      genders = Hash.new 0
      #for each gender type add one to the count
      user_posts.each do |post|
        post.commentsGenderPercentage.each do |key, value|
          genders[key] += value
        end
      end
        #calculate how many likes recieved
        total = genders.values.inject(:+)
        #calculate female percentage
          female_percentage = (100).to_f / (total).to_f * genders[:female].to_f || 0
        #calculate male percentage
          male_percentage = 100 - female_percentage || 0
        #store and return data into a hash
        {male: male_percentage, female: female_percentage}
    end


    def final_gender_percentage(likes_percentage, comments_percentage)
      #intialize empty hash
      genders = Hash.new 0
      #for each gender type add one to the count
      likes_percentage.each do |key, value|
          genders[key] += value
        end
      #for each gender type add one to the count
      comments_percentage.each do |key, value|
          genders[key] += value
        end
        #calculate how many likes recieved
        total = genders.values.inject(:+)
        #calculate female percentage
          female_percentage = (100).to_f / (total).to_f * genders[:female].to_f || 0
        #calculate male percentage
          male_percentage = 100 - female_percentage || 0
        #store and return data into a hash
        {total: {male: male_percentage, female: female_percentage}, likes: likes_percentage, comments: comments_percentage}
    end


end
