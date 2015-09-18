class Addagain < ActiveRecord::Migration
  def change
    add_column :fbcomments, :user_facebook_id, :string
  end
end
