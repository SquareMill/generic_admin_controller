Dummy::Application.routes.draw do
  namespace :admin do
    resources :messages
  end
end
