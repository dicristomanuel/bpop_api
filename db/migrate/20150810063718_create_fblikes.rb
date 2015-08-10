class CreateFblikes < ActiveRecord::Migration
  def change
    create_table :fblikes do |t|

      t.timestamps null: false
    end
  end
end
