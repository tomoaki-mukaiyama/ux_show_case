class AddValidationToScreenshotPath < ActiveRecord::Migration[6.0]
  def up
    change_column :user_flows, :screenshot_path, :string, null: false
  end
end