Gandlar::Application.routes.draw do

  get "static_pages/contact"
  get "static_pages/about"

  root "catalog_items#index"

end
