class RenameMainTagScreenShots < ActiveRecord::Migration[6.0]
  def change
    rename_column :screen_shots, :main_tag, :maintag_id
  end
end
