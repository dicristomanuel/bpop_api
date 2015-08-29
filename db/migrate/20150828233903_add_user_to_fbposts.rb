class AddUserToFbposts < ActiveRecord::Migration
  def change
    add_reference :fbposts, :user, index: true, foreign_key: true
  end
end
