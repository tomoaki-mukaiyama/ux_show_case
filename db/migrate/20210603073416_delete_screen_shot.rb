class DeleteScreenShot < ActiveRecord::Migration[6.0]
  def change
    drop_table :screen_shots
  end
end
