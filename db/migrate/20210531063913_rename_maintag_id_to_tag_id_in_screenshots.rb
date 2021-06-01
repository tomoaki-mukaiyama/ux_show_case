class RenameMaintagIdToTagIdInScreenshots < ActiveRecord::Migration[6.0]
  def change
    rename_column :screen_shots, :maintag_id, :tag_id
  end
end
