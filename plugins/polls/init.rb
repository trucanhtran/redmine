Redmine::Plugin.register :polls do
  name 'Polls plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :polls do
    permission :view_polls, polls: :index
    permission :vote_polls, polls: :vote
  end
  
  menu :project_menu, :polls, { controller: 'polls', action: 'index' }, caption: 'Polls', after: :activity, param: :project_id

  delete_menu_item :top_menu, :my_page
  delete_menu_item :top_menu, :help
  delete_menu_item :project_menu, :overview
  delete_menu_item :project_menu, :activity
  delete_menu_item :project_menu, :news

end
