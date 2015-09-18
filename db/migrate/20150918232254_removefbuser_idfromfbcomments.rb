class RemovefbuserIdfromfbcomments < ActiveRecord::Migration
  def change
    remove_column :fbcomments, :fbuser_id, :string
  end
end
