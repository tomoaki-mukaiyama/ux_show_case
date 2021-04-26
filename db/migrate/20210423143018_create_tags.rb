class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.boolean :IsFlowTag
      t.string :isTop
      t.string :isRecommend

      t.timestamps
    end
  end
end
