Rails.application.routes.draw do
  resources :rooms,  :replace_id_with => 'url'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end