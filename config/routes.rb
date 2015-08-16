Rails.application.routes.draw do

  resources :fbposts, only: [:index, :create, :show] do
    resources :fblikes, only: [:index, :create]
  end

  get '/get-gender-percentage/:bpopToken', to: 'fbposts#get_overall_gender_percentage'

#         Prefix Verb URI Pattern                                 Controller#Action
# fbpost_fblikes GET  /fbposts/:fbpost_id/fblikes(.:format)       fblikes#index
#                POST /fbposts/:fbpost_id/fblikes(.:format)       fblikes#create
#        fbposts GET  /fbposts(.:format)                          fbposts#index
#                POST /fbposts(.:format)                          fbposts#create
#         fbpost GET  /fbposts/:id(.:format)                      fbposts#show
#                GET  /get-gender-percentage/:bpopToken(.:format) fbposts#get_overall_gender_percentage



  end
