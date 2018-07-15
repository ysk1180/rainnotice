Rails.application.routes.draw do
  post '/callback' => 'linebot#callback'
  post '/sunglasses-callback' => 'sunglasses#callback'
end
