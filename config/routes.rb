Rails.application.routes.draw do
  resources "employees", only: [:index]
  resources "vacations", except: [:destroy]
  get "vacations/get_from_employee/:employee_id", to: "vacations#get_from_employee"
  # Defines the root path route ("/")
  # root "articles#index"
end
