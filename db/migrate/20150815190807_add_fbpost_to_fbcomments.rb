class AddFbpostToFbcomments < ActiveRecord::Migration
  def change
    add_reference :fbcomments, :fbpost, index: true, foreign_key: true
  end
end
