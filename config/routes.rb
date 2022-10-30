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
  end
    
end
