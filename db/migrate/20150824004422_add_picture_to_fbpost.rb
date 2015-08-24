class AddPictureToFbpost < ActiveRecord::Migration
  def change
    add_column :fbposts, :picture, :string
  end
end
