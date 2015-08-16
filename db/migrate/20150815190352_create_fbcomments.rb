class CreateFbcomments < ActiveRecord::Migration
  def change
    create_table :fbcomments do |t|
      t.string :user_name
      t.string :fbuser_id
      t.string :message

      t.timestamps null: false
    end
  end
end
