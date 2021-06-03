class DeleteTagTypeFromTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :tags, :tag_type ,:boolean
  end
end
