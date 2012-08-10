LinkedinAuth::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  match 'protected_page' => 'home#protected_page', as: :protected_page

  root :to => 'home#index'

end
