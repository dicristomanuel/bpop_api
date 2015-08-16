class AddBpoptokenToFbcomments < ActiveRecord::Migration
  def change
    add_column :fbcomments, :bpopToken, :string
  end
end
