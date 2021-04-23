class CreateUserFlows < ActiveRecord::Migration[6.0]
  def change
    create_table :user_flows do |t|
      t.references :product, null: false, foreign_key: true
      t.references :platform, null: false, foreign_key: true
      t.string :bg_color
      t.string :icon_path
      t.string :version
      t.string :video_time_string
      t.string :video_path

      t.timestamps
    end
  end
end
