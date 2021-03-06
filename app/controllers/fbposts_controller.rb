  class FbpostsController < ApplicationController
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
      if params[:limit]
        @fbposts = Fbpost.where("date > ? and bpoptoken = ?", sinceDate, params[:id]).first(params[:limit].to_i)
      else
        @fbposts = Fbpost.where("date > ? and bpoptoken = ?", sinceDate, params[:id])
      end
    else
      if params[:limit]
        @fbposts = Fbpost.where(bpoptoken: params[:id]).first(params[:limit])
      else
        @fbposts = Fbpost.where(bpoptoken: params[:id])
      end
    end
    render json: @fbposts, :except=> [:fb_user_token, :bpoptoken, :user_id, :fb_post_id]
  end


  # PATCH/PUT /fbposts/1
  # PATCH/PUT /fbposts/1.json
  def create
    @user = User.where(bpoptoken: params['fbpost']['bpoptoken']).first
    #check if post is already present in the database
    if @fbpost = Fbpost.find_by_fb_post_id(params[:fbpost][:fb_post_id])
        #update post's attribute
        @fbpost.update_attributes(fbpost_params)
          #calculate likes / comments only if attributes have changed (this will slow down the process)
          if @fbpost.changed?
            unless @fbpost.likes_data == '0'
            #follow the logic to create post's likes
              handle_likes(@fbpost)
            end
            unless @fbpost.comments_data == '0'
            #follow the logic to create post's comments
              handle_comments(@fbpost)
            end
          end
            #store every post's Id into a temp container
            method = 'post'
            posts_id_container(@user, method)

            if @fbpost[:is_last] == 'true'
              @user.update_attributes(is_parsing_complete: true)
            end
          #check if this is the last post sent to update
      else
        #if post is not present create new one
        @fbpost = @user.fbposts.create(fbpost_params)
        unless @fbpost.likes_data == '0'
        #follow the logic to create post's likes
          handle_likes(@fbpost)
        end
        unless @fbpost.comments_data == '0'
        #follow the logic to create post's comments
          handle_comments(@fbpost)
        end
        method = 'post'
        posts_id_container(@user, method)
      end

      if @fbpost[:is_last] == 'true'
        @user.update_attributes(is_parsing_complete: true)
        #compare the updated list of posts and check if there are any extra in database that need to be deleted
        @user.fbposts.each do |post|
          unless @user.tempPostsIdContainer.include?(post[:fb_post_id])
             Fbpost.where(fb_post_id: post[:fb_post_id]).destroy_all
          end
        end
      #reset temp container to empty
      method = 'delete'
      posts_id_container(@user, method)
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
    user_posts = Fbpost.where(bpoptoken:params['bpoptoken'])
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
        if params[:fbpost][:fb_post_id] == '590293087779465_620688661406574'
        end
        user.tempPostsIdContainer << params[:fbpost][:fb_post_id]
      end
      user.tempPostsIdContainer_will_change!
      user.save!
    end

    def string_to_json(this_string)
      JSON.parse this_string.gsub('=>', ':')
    end

    def set_user
      @user = User.find_by(bpoptoken: params[:fbpost][:bpoptoken])
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
          :bpoptoken,
          :fb_user_token,
          :fb_post_id,
          :is_last
        )
    end


    def fblikes_params(like, fb_user_token, bpoptoken, date)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, like['id'])
      return {
        user_facebook_id: like['id'],
        user_name: like['name'],
        gender: gender,
        bpoptoken: bpoptoken,
        date: date
      }
    end

    def fbcomments_params(comment, fb_user_token, bpoptoken, date)
      #find the gender of each of the users
      gender = get_gender(fb_user_token, comment['from']['id'])
      return {
        user_facebook_id: comment['from']['id'],
        user_name: comment['from']['name'],
        message: comment['message'],
        gender: gender,
        bpoptoken: bpoptoken,
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
          #TODO NOT FROM OWNER
          fbpost.fblikes.create(fblikes_params(like, fbpost.fb_user_token, fbpost.bpoptoken, fbpost.date)) #private section#
        end
        likesGenderPercentage = calculate_gender_percentage_likes(fbpost.fblikes)
        fbpost.update(
          likesGenderPercentage: likesGenderPercentage
         ) #private section#
      end
    end


    def handle_comments(fbpost)
      #if fbpost has comments get the string and parse it to JSON, for each comment create new fbcomment
        comments = string_to_json(fbpost.comments_data) #private section#
        comments.each do |comment|
          #check if the user who made the comment already made a comment for the same post (grabbing unique comments only)

          #if fbcomments array is empty and the comment doesn't come from the owner, create the new comment
          if fbpost.fbcomments.empty? and comment['from']['name'] != fbpost.owner
            fbpost.fbcomments.create(fbcomments_params(comment, fbpost.fb_user_token, fbpost.bpoptoken, fbpost.date)) #private section#
          #if fbcomments array is not empty and the comment doesn't come from the owner
          elsif comment['from']['name'] != fbpost.owner
            #if not empty check if the user already made a comment
            present = fbpost.fbcomments.any? {|existingComment| existingComment['user_name'].include?(comment['from']['name'])}
            #create comment if user hasn't commented yet on the same post
            unless present
                fbpost.fbcomments.create(fbcomments_params(comment, fbpost.fb_user_token, fbpost.bpoptoken, fbpost.date)) #private section#
            end
          end
        end
        commentsGenderPercentage = calculate_gender_percentage_comments(fbpost.fbcomments)
        fbpost.update(
          commentsGenderPercentage: commentsGenderPercentage
         ) #private section#
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
