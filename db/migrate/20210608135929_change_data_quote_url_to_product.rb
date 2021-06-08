class ChangeDataQuoteUrlToProduct < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :quote_url, :text
  end
end
