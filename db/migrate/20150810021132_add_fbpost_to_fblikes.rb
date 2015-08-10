class AddFbpostToFblikes < ActiveRecord::Migration
  def change
    add_reference :fblikes, :fbpost, index: true, foreign_key: true
  end
end
