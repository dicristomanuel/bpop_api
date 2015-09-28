class Add < ActiveRecord::Migration
  def change
    add_column :users, :bpoptoken, :string
    add_column :fbcomments, :bpoptoken, :string
    add_column :fblikes, :bpoptoken, :string
    add_column :fbposts, :bpoptoken, :string
  end
end
