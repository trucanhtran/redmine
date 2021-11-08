# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

post 'user/display_districts', to: 'users#display_districts'
post 'user/display_wards', to: 'users#display_wards'
post 'user/display_input', to: 'users#display_input'

Rails.application.routes.draw do 
    match 'my/avatar', :to => 'my#avatar', :via => [:get, :post]
    match 'my/save_avatar/:id', :to => 'my#save_avatar', :via => [:get, :post]
    match 'account/get_avatar/:id', :to => 'account#get_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
    match 'users/save_avatar/:id', :to => 'users#save_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
    match 'users/get_avatar/:id', :to => 'users#get_avatar', :constraints => {:id=>/\d+/}, :via => [:get, :post]
end