Rails.application.routes.draw do

  resources :fbposts,    only: [:index, :create, :show, :update]
  resources :fblikes,    only: [:index, :show]
  resources :fbcomments, only: [:index, :show]

  get 'stats/topfan'
  get '/get-gender-percentage/:bpopToken', to: 'fbposts#get_overall_gender_percentage'
  get '/stats/topfan/:bpopToken', to: 'stats#topfan'
  get '/stats/searchfan/:bpopToken', to: 'stats#searchFan'
  get '/stats/searchgroup/:bpopToken', to: 'stats#searchGroupFans'

end
