class AddNameColumnToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :name, :string
  end
end
