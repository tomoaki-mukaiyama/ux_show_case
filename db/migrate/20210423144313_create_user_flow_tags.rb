class CreateUserFlowTags < ActiveRecord::Migration[6.0]
  def change
    create_table :user_flow_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :user_flow, null: false, foreign_key: true

      t.timestamps
    end
  end
end
