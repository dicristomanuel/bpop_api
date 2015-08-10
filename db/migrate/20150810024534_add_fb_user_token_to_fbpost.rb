class AddFbUserTokenToFbpost < ActiveRecord::Migration
  def change
    add_column :fbposts, :fb_user_token, :text
  end
end
