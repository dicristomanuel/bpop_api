class StatsController < ApplicationController

  def topfan
    #create empty hash to store the fans
    fans = Hash.new 0
      sinceDate = Chronic.parse(params[:since]) || Chronic.parse('six months ago')
    #getting all the likes and the comments for the user
    userLikes         = Fblike.where("date > ? and bpoptoken = ?", sinceDate, params[:bpoptoken])
    userComments      = Fbcomment.where("date > ? and bpoptoken = ?", sinceDate, params[:bpoptoken])
       #grabbing all the usernames and adding 1 to the count everytime it appears
       userLikes.each do |user|
         fans[user[:user_name]] += 1
       end

       userComments.each do |user|
         fans[user[:user_name]] += 1
       end
       #sort hash by descending value
       fans = Hash[fans.sort_by{ |k, v| -v }]

       if params[:search]
         render json: fans[params[:search]]
       else
         render json: [{activeUsers: fans.count}, fans]
       end
  end


  def searchFan #add COMMENTS HERE
    likes    = Fblike.where(user_name: params[:userfan])
    comments = Fbcomment.where(user_name: params[:userfan])
    @postsFromLikes = []
    @postsFromComments = []


    unless likes.empty?
      likes.each do |like|
        @postsFromLikes += Fbpost.where(id: like.fbpost_id)
      end
    end

    unless comments.empty?
      comments.each do |comment|
        @postsFromComments += Fbpost.where(id: comment.fbpost_id)
      end
    end

    @allPosts = @postsFromLikes + @postsFromComments
      render :json => @allPosts, :except=>  [:fb_user_token, :bpoptoken, :user_id]
  end

  def searchGroupFans
    @common_likes = []
    names = []
    group_fans = []
    params[:users_fans].split(",").each {|fan| group_fans << fan}

    Fbpost.all.each do |post|
      unless post['likes_data'] == '0'
        JSON.parse(post['likes_data']).each do |like|
          names << like['name']
        end

        if group_fans.all? {|name| names.include?(name)}
          @common_likes << post
        end
      end

      unless post['comments_data'] == '0'
        JSON.parse(post['comments_data']).each do |comment|
          names << comment['from']['name']
        end

        if group_fans.all? {|name| names.include?(name)}
          @common_likes << post
        end
      end
      names = []
    end
    render json: @common_likes.uniq, :except=>  [:fb_user_token, :bpoptoken, :user_id]
  end

  def get_fan_id
    @fan = Fblike.where(user_name: params[:userFanName], bpoptoken: params[:bpoptoken])[0] || Fbcomment.where(user_name: params[:userFanName], bpoptoken: params[:bpoptoken])[0]
      @fan = @fan.user_facebook_id
      render json: [@fan, params[:userFanName]]
  end


end
