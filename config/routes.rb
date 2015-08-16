Rails.application.routes.draw do

  resources :fbposts, only: [:index, :create] do
    resources :fblikes, only: [:index, :create]
  end

  get '/get-gender-percentage/:bpop_token', to: 'fbposts#get_overall_gender_percentage'

#         Prefix Verb URI Pattern                           Controller#Action
# fbpost_fblikes GET  /fbposts/:fbpost_id/fblikes(.:format) fblikes#index
#                POST /fbposts/:fbpost_id/fblikes(.:format) fblikes#create
#        fbposts GET  /fbposts(.:format)                    fbposts#index
#                POST /fbposts(.:format)                    fbposts#create



  end
