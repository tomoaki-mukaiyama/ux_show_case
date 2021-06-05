class AddColumnToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :slug, :string, null: false
  end
end
