Rails.application.routes.draw do

  root 'welcome#index'

  get 'about/index'

  get 'terms/index'
end
