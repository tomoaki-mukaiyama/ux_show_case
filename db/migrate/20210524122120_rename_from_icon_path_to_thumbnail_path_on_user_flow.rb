class RenameFromIconPathToThumbnailPathOnUserFlow < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_flows, :icon_path, :thumbnail_path
  end
end
