Rails.application.routes.draw do

  root 'main#home'
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  resources :documents do
    get 'public/:uuid', action: :public_show, on: :collection, as: 'public_document'
    patch 'toggle_public_share', action: :toggle_public_share, on: :collection, as: :toggle_public_share
  end

end
