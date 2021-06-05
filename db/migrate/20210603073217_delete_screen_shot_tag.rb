class DeleteScreenShotTag < ActiveRecord::Migration[6.0]
  def change
    drop_table :screen_shot_tags
  end
end
