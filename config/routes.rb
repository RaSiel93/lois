Rails.application.routes.draw do
  root 'solver#index'

  resources :rule, :fact

  post 'solve/:purpose' => 'solver#solve'
end
