class DeleteTagIdFromUserFlow < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_flows, :tag_id, :bigint
  end
end
