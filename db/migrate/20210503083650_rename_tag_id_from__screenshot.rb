class RenameTagIdFromScreenshot < ActiveRecord::Migration[6.0]
  def change
    rename_column :screen_shots, :tag_id, :main_tag
  end
end
