class RenameMaintagIdToTagIdInUserflows < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_flows, :maintag_id, :tag_id
  end
end
