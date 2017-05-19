Rails.application.routes.draw do
  root :to => "messages#index"
  resources :messages, :except => [:new, :edit, :create]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
