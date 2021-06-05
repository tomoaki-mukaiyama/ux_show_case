class RemovePlatformIdFromScreenShots < ActiveRecord::Migration[6.0]
  def change
    remove_column :screen_shots, :platform_id, :bigint
  end
end
