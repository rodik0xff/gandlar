class RootCatalogItem < ActiveRecord::Base
	has_many :catalog_items
end
