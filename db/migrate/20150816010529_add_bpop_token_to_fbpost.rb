class AddBpopTokenToFbpost < ActiveRecord::Migration
  def change
    add_column :fbposts, :bpopToken, :string
  end
end
