class RenameTypeToTags < ActiveRecord::Migration[6.0]
  def change
    rename_column :tags, :type, :tag_type
  end
end
