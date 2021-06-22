class RemoveVideoPathFromUserFlow < ActiveRecord::Migration[6.0]
  def change
     remove_column :user_flows, :video_path, :string
  end
end
