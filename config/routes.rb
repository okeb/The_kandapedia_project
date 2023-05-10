Rails.application.routes.draw do
  resources :candies
  resources :questions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  namespace :admin do
    root to: 'home#index'
    # ... authenticated admin routes ...
    constraints Rodauth::Rails.authenticated(:admin) do
      get '/dashboard/', to: 'home#dashboard', as: 'dashboard'
    end
  end

  # ... authenticated routes ...
  constraints Rodauth::Rails.authenticated do

    resources :profiles

    post '/profiles/:id/see', to: 'profiles#see_profile', as: 'see_profile'
    post '/profiles/:id/follow', to: 'profiles#follow_profile', as: 'follow_profile'
    post '/profiles/:id/unfollow', to: 'profiles#unfollow_profile', as: 'unfollow_profile'
    post '/profiles/:id/blocking', to: 'profiles#blocking_profile', as: 'blocking_profile'
    post '/profiles/:id/unblocking', to: 'profiles#unblocking_profile', as: 'unblocking_profile'
    post '/profiles/:id/accept', to: 'profiles#accept_following', as: 'accept_following'
    post '/profiles/:id/decline', to: 'profiles#decline_following', as: 'decline_following'
    post '/profiles/:id/cancel', to: 'profiles#cancel_following', as: 'cancel_following'

    resources :questions do
      put 'add_to_readlist', to: 'questions#add_to_readlist'
      put 'remove_to_readlist', to: 'questions#remove_to_readlist'
      put 'bookmark', to: 'questions#toggle_to_bookmark'
      patch 'update_tags', to: 'questions#update_tags'

      put 'awesome_question', to: 'questions#add_awesome'
      put 'perfect_question', to: 'questions#add_perfect'
      put 'nice_question', to: 'questions#add_nice'
      put 'wrong_question', to: 'questions#add_wrong'
      put 'bad_question', to: 'questions#add_bad'
    end
    
    resources :candies do
      put 'bookmark', to: 'candies#toggle_to_bookmark'
      put 'like', to: 'candies#toggle_to_like'
      put 'boost', to: 'candies#toggle_to_boost'
      put 'view', to: 'candies#toggle_to_view'
    end
  end

end
