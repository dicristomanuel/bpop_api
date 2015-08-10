class RemoveIdentityTokenFromfbposts < ActiveRecord::Migration
  def change
  	remove_column(:fbposts, :identity_token)
  end
end
