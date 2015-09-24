class AddDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :is_parsing_complete, :boolean, :default => false
  end
end
