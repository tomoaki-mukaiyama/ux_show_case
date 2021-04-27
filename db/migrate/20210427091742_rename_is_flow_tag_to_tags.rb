class RenameIsFlowTagToTags < ActiveRecord::Migration[6.0]
  def change
    rename_column :tags, :IsFlowTag, :type
  end
end
