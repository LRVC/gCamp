Rails.application.routes.draw do
  root 'welcome#index'

  get 'terms/index'
end
