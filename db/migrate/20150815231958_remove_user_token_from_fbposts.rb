class RemoveUserTokenFromFbposts < ActiveRecord::Migration
  def change
    remove_column :fbposts, :user_token, :string
  end
end
