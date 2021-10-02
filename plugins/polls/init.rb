require 'redmine'

Rails.application.config.to_prepare do
  unless Issue.include?(IssuePatch)
    Issue.send(:include, IssuePatch)
  end
end


Redmine::Plugin.register :polls do
  name 'Polls plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  require_dependency 'polls_hook_listener'

  settings default: {'empty' => true}, partial: 'settings/poll_settings'

  menu :project_menu, :polls, { controller: 'polls', action: 'index' }, caption: 'Polls', after: :activity, param: :project_id

 
  project_module :polls do
    permission :view_polls, polls: :index
    permission :vote_polls, polls: :vote
  end


end
