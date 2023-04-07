Rails.application.routes.draw do
  resources "vacations", except: [:destroy]
  # Defines the root path route ("/")
  # root "articles#index"
end
