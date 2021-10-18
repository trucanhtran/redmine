def init
  # Administration menu extension
  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :staffs, { :controller => 'staffs', :action => 'index' }, :caption => :label_staffs,
              :html => { :class => 'icon icon-group groups' }, :if => Proc.new { |_| User.current.admin? }
  end
end

unless Redmine::Plugin.installed?(:easy_extensions)
  init
end


