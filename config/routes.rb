ActionController::Routing::Routes.draw do |map|

  # Reports
  map.report 'report/:year/:week', :controller => 'reports', :action => "show"

  # Delicious
  map.resource :delicious

  # Profile
  map.profile 'profile', :controller => "profile", :action => 'edit'
  map.new_profile 'profile/new', :controller => "profile", :action => 'new'
  map.create_profile 'profile/create', :controller => "profile", :action => 'create', :conditions => { :method => :post }
  map.edit_profile 'profile/edit', :controller => "profile", :action => 'edit', :conditions => { :method => :get }
  map.update_profile 'profile/update', :controller => "profile", :action => 'update', :conditions => { :method => :put }

  # Login/Logout
  map.login 'login', :controller => "user_sessions", :action => 'new'
  map.logout 'logout', :controller => "user_sessions", :action => 'destroy'
  map.rpx_token 'rpx_token', :controller => "user_sessions", :action => 'create'

  map.root :controller => "delicious", :action => 'index'
end
