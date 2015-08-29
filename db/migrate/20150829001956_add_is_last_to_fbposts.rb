class AddIsLastToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :is_last, :string
  end
end
