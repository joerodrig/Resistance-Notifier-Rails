Rails.application.routes.draw do
  get 'pages/index'

  resources :groups
  resources :users

  root 'groups#index'

   get 'groups/:id' => 'groups#show'
   post 'groups/:id/submit' => 'groups#message'

end
