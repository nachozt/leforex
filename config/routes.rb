Rails.application.routes.draw do
  root to: 'compare#index'

  resources :exchange_rates
  resources :institutions

  get 'today', to: 'compare#today'
end
