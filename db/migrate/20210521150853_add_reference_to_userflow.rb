class AddReferenceToUserflow < ActiveRecord::Migration[6.0]
  def change
    add_column :user_flows, :maintag_id, :bigint, index: true
    add_foreign_key :user_flows, :tags, column: :maintag_id
  end
end
