Rails.application.routes.draw do
  devise_for :users
  root to: 'items#index'
  resources :items do
    member do
      patch :sell  # ここにsellアクションへのルーティングを追加
    end
    resources :orders, only: [:index, :show, :create] 
  end
end
