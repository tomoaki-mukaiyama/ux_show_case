class AddQuoteUrlToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :quote_url, :string
  end
end
