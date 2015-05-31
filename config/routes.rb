Rails.application.routes.draw do

  devise_for :users
  root 'posts#index'

  resources(:users, only: [:show]) do
    resource :profile, only: [:show]
    resources :friends, only: [:index]
    resources :photos, only: [:index]
  end

  get :friend_requests, controller: :users

  resource :profile, only: [:edit, :update]

  patch "/cover_photo/:photo_id" => "profiles#update_cover", as: :update_cover_photo
  patch "/profile_photo/:photo_id" => "profiles#update_photo", as: :update_profile_photo

  resources :friends, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  resources(:photos, only: [:show, :new, :create, :destroy]) do
    resources :likes, only: [:create, :destroy], defaults: { likable: 'Photo' }
    resources(:comments, only: [:create, :destroy], defaults: { commentable: 'Photo' }) do
      resources :likes, only: [:create, :destroy], defaults: { likable: 'Comment' }
    end
  end

  resources(:posts, only: [:create, :destroy, :show]) do
    resources :likes, only: [:create, :destroy], defaults: { likable: 'Post' }
    resources(:comments, only: [:create, :destroy], defaults: { commentable: 'Post' }) do
      resources :likes, only: [:create, :destroy], defaults: { likable: 'Comment' }
    end
  end
end
