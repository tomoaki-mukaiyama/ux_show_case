class AddLocalVersionToUserflows < ActiveRecord::Migration[6.0]
  def change
    add_column :user_flows, :local_version, :integer
  end
end