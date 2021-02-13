Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:sessions, :password, :registration]
  devise_scope :user do
    resource :session, only: [], path: 'auth', controller: 'sessions', as: :user_session do
      post "sign_in" => :create
    end
    resource :registration, only: [:create], path: '/auth', controller: 'registrations'
  end
  resources :transactions, only: [:index, :create]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
