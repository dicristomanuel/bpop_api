class StatsController < ApplicationController

  def topfan
    #create empty hash to store the fans
    fans = Hash.new 0
      sinceDate = Chronic.parse(params[:since]) || Chronic.parse('six months ago')
    #getting all the likes and the comments for the user
    userLikes         = Fblike.where("date > ? and bpopToken == ?", sinceDate, params[:bpopToken])
    userComments      = Fbcomment.where("date > ? and bpopToken == ?", sinceDate, params[:bpopToken])
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


  def searchFan
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

    render json: [(@postsFromLikes + @postsFromComments).length, @postsFromLikes + @postsFromComments]
  end



end
