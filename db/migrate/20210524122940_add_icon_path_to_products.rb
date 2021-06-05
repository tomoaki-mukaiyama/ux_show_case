class AddIconPathToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :icon_path, :string
  end
end
