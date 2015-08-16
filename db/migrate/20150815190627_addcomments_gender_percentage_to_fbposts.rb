class AddcommentsGenderPercentageToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :commentsGenderPercentage, :string
  end
end
