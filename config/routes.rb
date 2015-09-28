Rails.application.routes.draw do

  get 'home/index'

  resources :fbposts,    only: [:index, :create, :show]
  resources :fblikes,    only: [:index, :show]
  resources :fbcomments, only: [:index, :show]

  get '/', to: 'home#index'
  get '/create-user/:bpoptoken', to: 'users#create_user'
  get 'stats/topfan'
  get '/get-gender-percentage/:bpoptoken', to: 'fbposts#get_overall_gender_percentage'
  get '/stats/topfan/:bpoptoken', to: 'stats#topfan'
  get '/stats/get-fan-id/:bpoptoken', to: 'stats#get_fan_id'
  get '/stats/searchfan/:bpoptoken', to: 'stats#searchFan'
  get '/stats/searchgroup/:bpoptoken', to: 'stats#searchGroupFans'
  get '/is-complete/:bpoptoken', to: 'users#is_complete'
  get '/is-complete-to-false/:bpoptoken', to: 'users#is_complete_to_false'

end
