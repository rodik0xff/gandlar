class CatalogItemsController < ApplicationController
  
  include CatalogItemsHelper

  def index

    @root_catalog_items = Hash.new
  
    root_items = getCatalogItems("DE")
    root_items.each do |root_item|
      catalog_items = Hash.new
      
      col_count = 1
      col_1 = ""
      col_2 = ""
      col_3 = ""
      item_id = ""
      root_item.catalog_items.each do |item|
        item_id = item.item_id
        if col_count == 1
          col_1 = item.item_name
        elsif col_count == 2
            col_2 = item.item_name
        elsif col_count == 3
            col_3 = item.item_name
            col_count = 0
            catalog_items[item.item_id] = {col1: col_1, col2:col_2, col3:col_3}
            col_1 = ""
            col_2 = ""
            col_3 = ""
        end
        col_count = col_count+1
      end
      if col_count > 1
        catalog_items[item_id] = {col1: col_1, col2:col_2, col3:col_3}
      end
      
      @root_catalog_items[root_item.item_id] = {name:root_item.item_description, subitems: catalog_items}
    end
  end # def index
end # class CatalogItemsController