Rails.application.routes.draw do

  resources :games
  root 'groups#index'
  resources :groups do
    collection do
      get  '/new'        => 'groups#new'
      get  '/:id'        => 'groups#show'
      post '/:id/slack'  => 'groups#slack_notify'
      post '/:id/submit' => 'groups#web_notify'
    end
  end

  resources :users do
    collection do
      get '/new' => 'users#new'
    end
  end
end
