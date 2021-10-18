# Redmine::SafeAttributes.send(:include, StaffsController)
require 'custom_query_model'
Query.send(:include, CustomQueryModel::QueryPatch)
Redmine::Plugin.register :redmine_fpt_staffs do
  # require_relative 'app/models/staffs_settings'
  name 'Redmine Fpt Staffs plugin'
  author 'TienDC5'
  description 'This is a plugin for FPT Telecom'
  version '0.0.1'
  # if 1==1
  menu :top_menu , :staffs, { :controller => 'staffs', :action => 'index' }, :caption => 'Staffs', html: { class: 'icon icon-group groups' }, :if => Proc.new { StaffsSettings.check_view_menu_top }
  # end
  menu :admin_menu , :staffs_settings, { :controller => 'staffs_settings', :action => 'index' }, :caption => 'Manager staffs', html: { class: 'icon icon-settings settings' }
  settings partial: 'staffs_settings/setting', default: {}
end

# require_relative 'after_init'
