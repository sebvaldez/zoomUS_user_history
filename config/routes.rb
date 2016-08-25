Rails.application.routes.draw do
  root 'welcome#home'

  resources :users

  get "find_users", to: 'users#find_users'

  get 'search_users', to: 'users#search'
end