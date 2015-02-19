Rails.application.routes.draw do

  get 'projects/index'

  root 'welcome#index'

  get '/terms', to: 'terms#index'

  get '/about', to: 'about#index'

  get '/faq', to: 'common_questions#index'


  resources :tasks
  resources :users
  resources :projects

end
