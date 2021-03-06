require 'redmine'
require_dependency 'users_controller_patch'
require_dependency 'user_patch'
require 'application_helper_user_patch'
require 'hooks/helper_issues_show_detail_after_setting_hook'


Rails.application.config.to_prepare do
  User.send(:include, UserPatch)
end

Redmine::Plugin.register :user_staffs do
  name 'User Staffs plugin'
  author 'Truc Anh'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Rails.configuration.to_prepare do
  UsersController.send(:prepend, UsersControllerPatch)
end







