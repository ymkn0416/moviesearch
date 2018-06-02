Rails.application.routes.draw do
  get 'index/index'
  get 'index/serch'
  post 'index/serch'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'showall/show'
  get 'showall', to: 'showall#show'
  get 'showall/tst'
  get 'index', to: 'index#index'
end
