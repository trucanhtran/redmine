module RedmineKnowledgebase
  class Hooks < Redmine::Hook::ViewListener
    def view_issues_show_description_bottom(context = {})
    # the controller parameter is part of the current params
    object
    # This will render the partial into a string and return it.
    context[:controller].send(:render_to_string, {
    :partial => "
    redmine_knowledgebase/hooks/view_issues_show_description_bottom",
    :locals => context
    })
    # Instead of the above statement, you could return any string
    generated
    # by your code. That string will be included into the view
    end
  end
end