Redmine::Plugin.register :redmine_knowledgebase do
  name 'Redmine Knowledgebase plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    :sort_category_tree => true,
    :show_category_totals => true,
    :summary_limit => 5,
    :disable_article_summaries => false
    }, :partial => 'settings/knowledgebase_settings'

  menu :project_menu,
    :articles,
    { :controller => 'articles', :action => 'index' },
    :caption => :knowledgebase_title,
    :after => :activity,
    :param => :project_id
      
  project_module :knowledgebase do
    permission :create_articles, {
    :knowledgebase => :index,
    :articles => [:show, :tagged, :new, :create, :preview],
    :categories => [:index, :show]
    }

    permission :comment_and_rate_articles, {
      :articles => [:index, :show, :tagged, :rate,
      :comment, :add_comment],
      :categories => [:index, :show]
    }

      permission :manage_category_whitelist, {
      :articles => :index,
      :categories => [:index, :show, :edit, :update]
    }

  # ...
  end
end
