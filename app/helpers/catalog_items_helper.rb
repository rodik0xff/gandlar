module CatalogItemsHelper

  CatalogItemsID = 
  { 
    "DE" => 
    {
      "Apparel"=> "78689031",  
      "Automotive"=> "78191031",
      "Baby"=> "357577011",
      "Beauty"=> "64257031",
      "Books"=> "541686",
      "Classical"=> "542676",  
      "DVD"=> "547664",
      "Electronics"=> "569604",
      "ForeignBooks"=> "54071011",
      "Grocery"=> "340846031",
      "Jewelry"=> "327473011",
      "KindleStore"=> "530484031",
      "Kitchen"=> "3169011",
      "Lighting"=> "213083031",
      "Luggage & Bags"=> "2454118031",
      "Magazines"=> "1161658",
      "MP3Downloads"=> "77195031",
      "MusicalInstruments"=> "340849031",
      "OfficeProducts"=> "192416031",
      "Software"=> "542064",
      "SoftwareVideoGames "=> "541708",
      "SportingGoods"=> "16435121",
      "Toys"=> "12950661",
      "Watches"=> "193708031"
      
      #<-- Duplicate -->
      #HealthPersonalCare"=> "64257031" 
      #"Music"=> " 542676"
      #"PCHardware"=> "  569604"
      #"Photo"=> " 569604"
      #"Video"=> " 547664"
      #"VideoGames"=> "  541708"

      #<-- Error -->
      #{}"HomeGarden"=> "10925241"
      #{}"MobileApps"=> "1661648031"
      #{}"OutdoorLiving"=> "10925051"
      #{}"VHS"=> "547082"

    },# "DE"
    
    "CA" =>
    {      
      "Baby"                => "3561346011",
      "Books"               => "927726",
      "Classical"           => "962454",
      "Electronics"         => "677211011",
      "HealthPersonalCare"  => "6205177011",
      "KindleStore"         => "2972705011",
      "Kitchen"             => "2206275011",
      "LawnGarden"          => "6205499011",  
      "PetSupplies"         => "6205514011", 
      "Software"            => "3234171",
      "Toys"                => "6205517011",
      "VHS"                 => "962072",
      "VideoGames"          => "110218011"
      
      #<-- Dublicate -->
      #"ForeignBooks"        => "927726",
      #"Music"               => "962454",
      #"Video"               => "962454",

      #<-- Error -->
      #"SoftwareVideoGames"  => "3323751",
    }#CA
  }# CatalogItemsID


  #< -------------- TEST --------------> 
  def testSesrch()
  end

  #< -------------- Fill DB --------------> 
  #fill catalog item description values into CatalogItemDescription DB
  def fillCatalogItemsDescriptionTable(locale)
    CatalogItemsID[locale].each do |description, id|
      new_item_desctiption = CatalogItemDescription.new(item_id:id, item_description:description, locale:locale)
      new_item_desctiption.save
    end
  end

  #fill root catalog items int CatalogItem DB
  def fillCatalogItemsIntoDB(locale)
    CatalogItemsID[locale].each do |description, id|  
      catalog_items_hash = getCatalogItemHash(id,locale)
      new_root_item = parseBrouseLookupResponse(getCatalogItemHash(id,locale),locale)
      if !new_root_item.nil?
        new_root_item.save
      end
    end
  end

  
  #< -------------- Helpers --------------> 
  #check item update time expare
  def checkUpdateTime(item)
    start_date = Time.now - 10.days #TODO Get days number from config
    item_date = item.updated_at
    start_date <= item_date
  end

  def parseBrouseLookupResponse(respons_hash,locale)
    root_item_id = respons_hash["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["BrowseNodeId"]
    root_item_name = respons_hash["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["Name"]
    root_item_description = getCatalogItemDescription(root_item_id,locale)
    new_root_item = RootCatalogItem.new(item_id:root_item_id, item_name:root_item_name, item_description:root_item_description, locale:locale)
      
    catalog_items = respons_hash["BrowseNodeLookupResponse"]["BrowseNodes"]["BrowseNode"]["Children"]["BrowseNode"]
    catalog_items.each do |item|
      new_root_item.catalog_items.build(item_id:item["BrowseNodeId"], item_name:item["Name"], item_description:item["Name"],locale:locale)
    end
    
    return new_root_item
  end


  def getCatalogItems(locale)
    root_catalog_items = Array.new
    CatalogItemDescription.where(locale:locale).each do |root_item_description|
      root_item = RootCatalogItem.where(item_id:root_item_description.item_id, locale:locale)
      if !root_item.empty?
        root_catalog_items.push(root_item.first)
      else
        new_catalog_item = parseBrouseLookupResponse(getCatalogItemHash(root_item_description.item_id,locale),locale)
        if !new_catalog_item.nil?
          new_catalog_item.save
          root_catalog_items.push(new_catalog_item)
        end
      end
    end
    return root_catalog_items
  end

  #< -------------- DB --------------> 
  #find all catalog item description by locale in DB
  def getAllCatalogItemsDescription(locale)
    all_items_description = CatalogItemDescription.where(locale:locale)
  end

  #find catalog item description by item_id in DB
  def getCatalogItemDescription(item_id, locale)
    catalog_description_list = CatalogItemDescription.where(item_id:item_id, locale:locale)
    if !catalog_description_list.empty?
      catalog_description = catalog_description_list.first.item_description
    else
      catalog_description = "UNDEFENED"
    end
  end


  #< -------------- WS -------------->
  #find catalog item use WS
  def getCatalogItemHash(item_id, locale)
    request = Vacuum.new(locale)
    request.associate_tag = 'foobar'
    params = {'BrowseNodeId' => item_id}
    response = request.browse_node_lookup(params)
    catalog_items_hash = response.to_h  
  end
end












