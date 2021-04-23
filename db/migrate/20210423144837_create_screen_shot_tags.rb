class CreateScreenShotTags < ActiveRecord::Migration[6.0]
  def change
    create_table :screen_shot_tags do |t|
      t.references :screen_shot, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
