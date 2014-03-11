class CreateCatalogItems < ActiveRecord::Migration
  def change
    create_table :catalog_items do |t|
      t.integer :item_id
      t.string :item_name
      t.string :item_description
      t.string :locale
      t.belongs_to :root_catalog_item
      
      t.timestamps
    end
  end
end
