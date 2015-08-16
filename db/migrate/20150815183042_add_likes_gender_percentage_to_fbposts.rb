class AddLikesGenderPercentageToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :likesGenderPercentage, :string
  end
end
