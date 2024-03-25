Rails.application.routes.draw do
  scope '/' do
    post 'login', to: 'sessions#create'
  end

  scope :profiles do
    get ':username', to: "profiles#show"
  end
  
  resources :events
  resources :posts
  
  resources :users do
    get 'posts', to: "users#posts_index"
  end
end
