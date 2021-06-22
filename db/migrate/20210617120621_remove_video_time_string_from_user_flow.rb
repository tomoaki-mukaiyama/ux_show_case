class RemoveVideoTimeStringFromUserFlow < ActiveRecord::Migration[6.0]
  def change
      remove_column :user_flows, :video_time_string
  end
end
