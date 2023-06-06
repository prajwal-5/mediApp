Rails.application.routes.draw do
  resources :appointments
  resources :users
  resources :doctors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'appointment_created', to: 'appointments#appointment_created'
  get 'show', to: 'appointments#show'
  post 'show', to: 'appointments#show'
  get 'appointment/update_slot', to: 'appointments#update_slot', as: 'update_slot'
  get 'user/new', to: 'users#update_currency', as: 'update_currency'
  get 'csv_invoice', to: 'appointments#csv_invoice', as: 'csv_invoice'
  get 'txt_invoice', to: 'appointments#txt_invoice', as: 'txt_invoice'
  get 'pdf_invoice', to: 'appointments#pdf_invoice', as: 'pdf_invoice'

  # Defines the root path route ("/")
  root "doctors#index"
end
