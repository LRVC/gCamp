Rails.application.routes.draw do

  get 'projects/index'

  root 'welcome#index'

  get '/terms', to: 'terms#index'

  get '/about', to: 'about#index'

  get '/faq', to: 'common_questions#index'

  get 'sign-up', to: 'registrations#new'

  post 'sign-up', to: 'registrations#create'

  get 'sign-in', to: 'authentication#new'

  post 'sign-in', to: 'authentication#create'

  get 'sign-out', to: 'authentication#destroy'

  resources :users
  resources :projects do
    resources :tasks
  end


end
