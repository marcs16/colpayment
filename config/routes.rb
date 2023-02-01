# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  get 'payu/result', to: 'payu#result'
  post 'payu/confirmation', to: 'payu#confirmation'
  resources :charges, only: %i[index new create]
  root 'charges#index'
end
