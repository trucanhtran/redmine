module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        after_update :after_save_custom_workflows
      end
    end
  
    module InstanceMethods
      def after_save_custom_workflows
        if self.status.id == 3 && !self.actual_end_date_issue.present?
         self.actual_end_date_issue = Time.now
          p self.actual_end_date_issue
          puts "-------------------------------------------------------------------"
          self.save
        end
      end
    end
end