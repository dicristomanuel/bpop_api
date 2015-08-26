class AddFbpostidToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :fb_post_id, :string
  end
end
