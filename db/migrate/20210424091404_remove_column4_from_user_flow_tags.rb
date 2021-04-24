class RemoveColumn4FromUserFlowTags < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_flow_tags, :column_4, :string
  end
end
