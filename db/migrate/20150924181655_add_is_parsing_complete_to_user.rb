class AddIsParsingCompleteToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_parsing_complete, :string
  end
end
