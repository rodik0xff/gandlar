class CatalogItem < ActiveRecord::Base
	belongs_to :root_catalog_item
end
