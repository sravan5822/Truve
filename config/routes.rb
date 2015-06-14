Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :images

  resources :comments

  resources :products do
    member do
      post "/add_comment" => "products#add_comment"
    end
  end
  resources :users do
    resources :messages do
      collection do
        get "/conversations/:sender_id" => "messages#conversation"
      end
    end
  end

  get "/asdftest" => "messages#push_test"

  get "/auth/:provider/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", as: :signout

  get "/fetch_friends_lists" => 'users#reload_friends_list'

  root 'pages#homepage'
end