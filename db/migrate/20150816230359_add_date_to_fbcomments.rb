class AddDateToFbcomments < ActiveRecord::Migration
  def change
    add_column :fbcomments, :date, :string
  end
end
