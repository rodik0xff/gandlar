class CreateCatalogItemDescriptions < ActiveRecord::Migration
  def change
    create_table :catalog_item_descriptions do |t|
      t.integer :item_id
      t.string :item_description
      t.string :locale

      t.timestamps
    end
  end
end
