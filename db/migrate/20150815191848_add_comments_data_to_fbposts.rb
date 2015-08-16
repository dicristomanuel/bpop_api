class AddCommentsDataToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :comments_data, :text
  end
end
