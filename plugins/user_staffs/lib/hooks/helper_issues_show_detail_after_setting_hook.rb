  module Hooks
    class HelperIssuesShowDetailAfterSettingHook < Redmine::Hook::ViewListener
      # Deliverable changes for the journal use the Deliverable subject
      # instead of the id
      #
      # Context:
      # * :detail => Detail about the journal change
      #
     def get_name
      p "-----------------hello"
     end

      end
  end
