Rails.application.routes.draw do

  devise_for :users
  root 'posts#index'

  resources(:users, only: [:index, :show]) do
    resource :profile, only: [:show]
    resources :friends, only: [:index]
    resources :photos, only: [:index]
  end

  get :friend_requests, controller: :friends

  resources :posts, only: [:create, :destroy, :show]
  resources :photos, only: [:show, :new, :create, :destroy]
  resources :likes, :comments, :friends, only: [:create, :destroy]
  resource :profile, only: [:edit, :update]

  patch "/cover_photo/:photo_id" => "profiles#update_cover", as: :update_cover_photo
  patch "/profile_photo/:photo_id" => "profiles#update_photo", as: :update_profile_photo

end
