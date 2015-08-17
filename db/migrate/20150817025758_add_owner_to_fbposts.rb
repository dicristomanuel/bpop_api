class AddOwnerToFbposts < ActiveRecord::Migration
  def change
    add_column :fbposts, :owner, :string
  end
end
