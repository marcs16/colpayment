Rails.application.routes.draw do
  get 'charges/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "charges#index"
end
