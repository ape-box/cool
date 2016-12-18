Rails.application.routes.draw do

  root 'static#index'

  get 'auth' => 'auth#index'
  post 'auth/login' => 'auth#login'

  get 'recipients' => 'recipients#index'
  post 'recipients' => 'recipients#create'

  get 'payments' => 'payments#index'
  post 'payments' => 'payments#create'

end
