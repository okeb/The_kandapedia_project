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
    resources :profiles
    
    resources :questions do
      put "add_to_readlist", to: 'questions#add_to_readlist'
      put "remove_to_readlist", to: 'questions#remove_to_readlist'
      put "bookmark", to: 'questions#toggle_to_bookmark'

      put "add_love", to: 'questions#add_love'
      put "add_perfect", to: 'questions#add_perfect'
      put "add_nice", to: 'questions#add_nice'
      put "add_wrong", to: 'questions#add_wrong'
      put "add_bad", to: 'questions#add_bad'
    end
  end
    
end
