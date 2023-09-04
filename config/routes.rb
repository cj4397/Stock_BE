Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  get '/market' => 'stock#create_market_stocks'             #used

  post '/trader' => 'user#trader'                           #used
  post '/create' => 'user#create'                           #used
  post '/sign-in' => 'user#signin'                          #used
  # put '/edit' => 'user#update'
  # delete '/delete' => 'user#delete'
  post '/admin' => 'user#admin'                             #used

  put '/admin/confirm' =>'user#admin_confirm'               #used
  post '/transactions' => 'user#transaction'                #used

  post '/request' => 'request#user_request'                 #used
  
  post '/transaction/create' => 'transaction_history#create'    #used
  post '/transaction/sell' => 'transaction_history#sell'    #used




end
