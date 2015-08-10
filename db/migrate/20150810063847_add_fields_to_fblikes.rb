class AddFieldsToFblikes < ActiveRecord::Migration
  def change
    add_column :fblikes, :user_facebook_id, :string
    add_column :fblikes, :user_name, :string
    add_column :fblikes, :gender, :string
    add_reference :fblikes, :fbpost, index: true, foreign_key: true
  end
end
