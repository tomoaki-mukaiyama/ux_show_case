class RemoveTitleFromUserFlow < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_flows, :title, :string
  end
end
