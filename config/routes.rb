Rails.application.routes.draw do

  get '/albums/search' => 'albums#search'
  post '/album/searchAlbum' => 'albums#searchAlbum'

  resources :albums do
    resources :songs
  end

end
