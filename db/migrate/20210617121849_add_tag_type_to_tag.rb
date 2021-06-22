class AddTagTypeToTag < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :tag_type, :string
  end
end
