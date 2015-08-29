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

# Prefix Verb  URI Pattern                                 Controller#Action
# stats_topfan GET   /stats/topfan(.:format)                     stats#topfan
# fbposts GET   /fbposts(.:format)                          fbposts#index
#        POST  /fbposts(.:format)                          fbposts#create
# fbpost GET   /fbposts/:id(.:format)                      fbposts#show
#        PATCH /fbposts/:id(.:format)                      fbposts#update
#        PUT   /fbposts/:id(.:format)                      fbposts#update
# fblikes GET   /fblikes(.:format)                          fblikes#index
# fblike GET   /fblikes/:id(.:format)                      fblikes#show
# fbcomments GET   /fbcomments(.:format)                       fbcomments#index
# fbcomment GET   /fbcomments/:id(.:format)                   fbcomments#show
#        GET   /get-gender-percentage/:bpopToken(.:format) fbposts#get_overall_gender_percentage
#        GET   /stats/topfan/:bpopToken(.:format)          stats#topfan
#        GET   /stats/searchfan/:bpopToken(.:format)       stats#searchFan
#        GET   /stats/searchgroup/:bpopToken(.:format)     stats#searchGroupFans
