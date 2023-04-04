Rails.application.routes.draw do
  resources :questions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  constraints Rodauth::Rails.authenticated do
    # ... authenticated routes ...
    # resources :questions do
    #   put 'upvote', to: 'questions#upvote'
    # end
    resources :profiles do
      post "follow", to: "profile#follow", as: "follow_profile"
      post "unfollow", to: "profile#unfollow", as: "unfollow_profile"
    end
    
    resources :questions do
      put "add_to_readlist", to: 'questions#add_to_readlist'
      put "remove_to_readlist", to: 'questions#remove_to_readlist'
      put "bookmark", to: 'questions#toggle_to_bookmark'
      patch "update_tags", to: 'questions#update_tags'

      put "awesome_question", to: 'questions#add_awesome'
      put "perfect_question", to: 'questions#add_perfect'
      put "nice_question", to: 'questions#add_nice'
      put "wrong_question", to: 'questions#add_wrong'
      put "bad_question", to: 'questions#add_bad'
    end
  end
    
end
