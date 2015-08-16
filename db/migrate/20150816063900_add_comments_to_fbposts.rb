class AddCommentsToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :comments, :string
  end
end
