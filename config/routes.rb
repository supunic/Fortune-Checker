Rails.application.routes.draw do
  root 'fortunes#index'
  get 'pps/index'
  get 'toss/index'
  resources :fortunes, only: [:show] do
    member do
      get :check
    end
  end
end
