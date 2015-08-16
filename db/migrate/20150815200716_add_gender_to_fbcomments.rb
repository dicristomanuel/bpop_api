class AddGenderToFbcomments < ActiveRecord::Migration
  def change
    add_column :fbcomments, :gender, :string
  end
end
