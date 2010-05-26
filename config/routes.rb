ActionController::Routing::Routes.draw do |map|
  
  map.resources :artists
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
