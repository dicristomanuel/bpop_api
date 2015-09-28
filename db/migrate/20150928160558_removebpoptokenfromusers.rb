class Removebpoptokenfromusers < ActiveRecord::Migration
  def change
    remove_column :users, :bpopToken, :string
    remove_column :fbcomments, :bpopToken, :string
    remove_column :fblikes, :bpopToken, :string
    remove_column :fbposts, :bpopToken, :string
  end
end
