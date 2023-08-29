Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  put '/stock_update' =>'stock#update_stock'
  get '/stocks' => 'stock#create_market_stocks'

  post '/trader' => 'user#trader'
  post '/create' => 'user#create'
  post '/sign-in' => 'user#signin'
  put '/edit' => 'user#update'
  delete '/delete' => 'user#delete'
  post '/admin' => 'user#admin'

  put '/admin/confirm' =>'user#admin_confirm'
  post '/transactions' => 'user#transaction'

  post '/request' => 'request#user_request'
  
  post '/transaction/create' => 'transaction_history#create'
  post '/transaction/sell' => 'transaction_history#sell'


end
