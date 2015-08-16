class AddDateToFblikes < ActiveRecord::Migration
  def change
    add_column :fblikes, :date, :string
  end
end
