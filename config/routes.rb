Rails.application.routes.draw do

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :members, only: [:index, :show]
    resources :tasks, only: [:index, :show, :edit]
    resources :subtasks, only: [:index, :show, :edit]
  end

  # 会員用
  # URL /members/sign_in ...
  devise_for :members,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    get '/about' => "homes#about", as: 'about'
    get '/members/mypage' => 'members#show', as: 'mypage'
    # members/editのようにするとdeviseのルーティングとかぶってしまうためinformationを付け加えている。
    get '/members/information/edit' => 'members#edit', as: 'edit_information'
    patch '/members/information' => 'members#update', as: 'update_information'
    # 退会機能
    get '/members/unsubscribe' => 'members#unsubscribe', as: 'confirm_unsubscribe'
    put '/members/information' => 'members#update'
    patch '/members/withdraw' => 'members#withdraw', as: 'withdraw_member'

    resources :tasks, only: [:index, :show, :edit]
    resources :subtasks, only: [:index, :show, :edit]

    resources :tasks do
      resources :subtasks
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
