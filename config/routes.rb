Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  scope '/api' do    
    resources :fighters do
      get 'list/:first' => :list
    end    
  end

  
end
