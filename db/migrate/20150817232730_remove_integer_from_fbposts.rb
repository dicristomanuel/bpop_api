class RemoveIntegerFromFbposts < ActiveRecord::Migration
  def change
    remove_column :fbposts, :integer, :string
  end
end
