# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
# resources :staffs
# match '/staffs/index', :to => 'staffs#index', :via => [:get, :post]
# post '/staffs/new', :to => 'staffs#new'
# match '/staffs/edit', :to => 'staffs#index', :via => [:get, :post]
# match '/staffs', :controller => 'staffs', :action => 'destroy', :via => :delete
# resources :staffs
get 'staffs/:copy_from/copy', :to => 'staffs#new', :as => 'copy_staff'
get '/staffs/filter', :to => 'staffs#filter', :as => 'staffs_filter'
get '/staffs/dashboard', :to => 'staffs#dashboard', :as => 'staffs_dashboard'

resources :staffs do
  collection do
  	get 'change_center'
  	get 'change_department'
    post 'change_team_leader'
  end
end
# match 'staffs/:copy_from/copy', :to => 'staffs#copy', :via => [:get, :post] , :as => 'copy_staff'
# get '/staffs_settings/new', :to => 'staffs_settings#new', :as => 'new_staffs_settings'
# resources :staffs_settings
# get '/staffs_settings/autocomplete', :to => 'staffs_settings#autocomplete', :as => 'autocomplete_staffs_settings'
resources :staffs_settings do
  collection do
    get 'autocomplete'
    get 'change_center'
    # get '(?:tab)', :action => 'index', :as => 'settings'
    # get '(/:tab)', :action => 'index', :as => 'settings'
  end
# get 'staffs_settings?:tab', :to => 'staffs_settings#index', :as => 'staffs_setting'

end