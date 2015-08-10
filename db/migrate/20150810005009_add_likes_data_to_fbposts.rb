class AddLikesDataToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :likes_data, :text
  end
end
