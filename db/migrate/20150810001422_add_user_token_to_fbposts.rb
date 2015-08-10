class AddUserTokenToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :user_token, :text
  end
end
