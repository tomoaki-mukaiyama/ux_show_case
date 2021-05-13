class AddIndexTags < ActiveRecord::Migration[6.0]
  def change
    add_index :tags, :slug, unique: true
  end
end
