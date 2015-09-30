Rails.application.routes.draw do

  root 'groups#index'
  resources :groups do
    collection do
      get  '/new'        => 'groups#new'
      get  '/:id'        => 'groups#show'
      post '/:id/submit' => 'groups#message'
    end
  end

  resources :users do
    collection do
      get '/new' => 'users#new'
    end
  end
end
