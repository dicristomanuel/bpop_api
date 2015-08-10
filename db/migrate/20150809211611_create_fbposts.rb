class CreateFbposts < ActiveRecord::Migration
  def change
    create_table :fbposts do |t|
      t.text :story
      t.text :message
      t.string :likes
      t.string :integer
      t.string :url
      t.string :date
      t.text :identity_token

      t.timestamps null: false
    end
  end
end
