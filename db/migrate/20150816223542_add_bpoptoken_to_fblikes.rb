class AddBpoptokenToFblikes < ActiveRecord::Migration
  def change
    add_column :fblikes, :bpopToken, :string
  end
end
