class ChangeThumbnailPathToScreenShotPathInUserflow < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_flows, :thumbnail_path, :screenshot_path
  end
end
