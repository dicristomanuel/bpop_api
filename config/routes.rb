Rails.application.routes.draw do

  resources :fbposts,    only: [:index, :create, :show]
  resources :fblikes,    only: [:index, :show]
  resources :fbcomments, only: [:index, :show]

  get 'stats/topfan'
  get '/get-gender-percentage/:bpopToken', to: 'fbposts#get_overall_gender_percentage'
  get '/stats/topfan/:bpopToken', to: 'stats#topfan'
  get '/stats/get-fan-id/:bpopToken', to: 'stats#get_fan_id'
  get '/stats/searchfan/:bpopToken', to: 'stats#searchFan'
  get '/stats/searchgroup/:bpopToken', to: 'stats#searchGroupFans'
  get '/is-complete/:bpopToken', to: 'users#is_complete'
  get '/is-complete-to-false/:bpopToken', to: 'users#is_complete_to_false'

end
