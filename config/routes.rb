Rails.application.routes.draw do
  resources "employees", only: [:index]
  resources "vacations", except: [:destroy]
  # Defines the root path route ("/")
  # root "articles#index"
end
