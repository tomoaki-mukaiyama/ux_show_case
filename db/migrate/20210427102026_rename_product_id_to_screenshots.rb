class RenameProductIdToScreenshots < ActiveRecord::Migration[6.0]
  def change
    rename_column :screen_shots, :product_id, :userflow_id
  end
end
