class AddBpopTokenToFbposs < ActiveRecord::Migration
  def change
    add_column :fbposts, :bpop_token, :text
  end
end
