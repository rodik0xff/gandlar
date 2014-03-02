class CatalogItemsController < ApplicationController
  
  include CatalogItemsHelper

  def index

    req = Vacuum.new('DE')
    req.associate_tag = 'foobar'

    @all_my_ids = Hash.new

    CatalogItemsID["DE"].each do |key, value|

      if not value.empty?
        params = { 'BrowseNodeId'  => value }

        @all_my_ids[key] = value
       
        res = req.browse_node_lookup(params)
     
        #binding.pry
        
        #aFile = File.new("Node_" + value + "_ID.xml" , "w")
        #aFile.write(res.to_h.to_xml)
        #aFile.close

     end # if 

   end # foreach

  end # def index

end # class CatalogItemsController
