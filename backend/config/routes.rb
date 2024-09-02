Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  post '/api/auth/login', to: 'auth#login'
  post '/api/auth/register', to: 'auth#register'
  get '/api/auth/confirm/:token', to: 'auth#confirm'
  post '/api/auth/email/forgot', to: 'auth#forgot_password'
  post '/api/auth/email/reset/:token', to: 'auth#reset_password'

  get '/api/account/detail', to: 'account#me'
  post '/api/account/update', to: 'account#update'
  post '/api/account/password', to: 'account#password'
  post '/api/account/upload', to: 'account#upload'
  get '/api/account/token', to: 'account#token'
  get '/api/account/activity', to: 'account#activity'

  get '/api/notification/list', to: 'notification#list'
  get '/api/notification/read/:id', to: 'notification#read'
  delete '/api/notification/remove/:id', to: 'notification#remove'

  get '/api/article/list', to: 'article#list'
  post '/api/article/create', to: 'article#create'
  get '/api/article/read/:slug', to: 'article#read'
  put '/api/article/update/:id', to: 'article#update'
  delete '/api/article/remove/:id', to: 'article#remove'
  get '/api/article/user', to: 'article#user'
  post '/api/article/upload', to: 'article#upload'
  get '/api/article/words', to: 'article#word'

end
