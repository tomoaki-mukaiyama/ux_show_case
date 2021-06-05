class AddTitleToUserFlow < ActiveRecord::Migration[6.0]
  def change
    add_column :user_flows, :title, :string
  end
end
