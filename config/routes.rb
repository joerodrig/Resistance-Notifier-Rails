Rails.application.routes.draw do

  root 'groups#index'
  resources :groups do
    collection do
      get  '/new'        => 'groups#new'
      get  '/:id'        => 'groups#show'
      post '/:id/submit' => 'groups#message'
    end
  end

end
