class AddTempPostsIdContainerToUser < ActiveRecord::Migration
  def change
    add_column :users, :tempPostsIdContainer, :string
  end
end
