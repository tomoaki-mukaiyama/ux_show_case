class RenameUserflowIdToScreenShots < ActiveRecord::Migration[6.0]
  def change
    rename_column :screen_shots, :userflow_id, :user_flow_id
  end
end
