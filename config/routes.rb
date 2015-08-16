Rails.application.routes.draw do

  resources :fbposts, only: [:index, :create, :show]
  resources :fblikes, only: [:index, :create, :show]
  resources :fbcomments, only: [:index, :create, :show]

  get '/get-gender-percentage/:bpopToken', to: 'fbposts#get_overall_gender_percentage'

end

#       Prefix Verb URI Pattern                                 Controller#Action
#      fbposts GET  /fbposts(.:format)                          fbposts#index
#              POST /fbposts(.:format)                          fbposts#create
#       fbpost GET  /fbposts/:id(.:format)                      fbposts#show
#      fblikes GET  /fblikes(.:format)                          fblikes#index
#              POST /fblikes(.:format)                          fblikes#create
#       fblike GET  /fblikes/:id(.:format)                      fblikes#show
#   fbcomments GET  /fbcomments(.:format)                       fbcomments#index
#              POST /fbcomments(.:format)                       fbcomments#create
#    fbcomment GET  /fbcomments/:id(.:format)                   fbcomments#show
#              GET  /get-gender-percentage/:bpopToken(.:format) fbposts#get_overall_gender_percentage
