class CreateRootCatalogItems < ActiveRecord::Migration
  def change
    create_table :root_catalog_items do |t|
      t.integer :item_id
      t.string :item_name
      t.string :item_description
      t.string :locale

      t.timestamps
    end
  end
end
