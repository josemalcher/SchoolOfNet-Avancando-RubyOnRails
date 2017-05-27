Rails.application.routes.draw do
  resources :albums do
    resources :songs
  end
end
