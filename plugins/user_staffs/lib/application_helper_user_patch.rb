# require_dependency 'users_helper' 

# module StaffsHelper
#   module UsersHelperPatch
#     def self.included(base) # :nodoc:    
#       base.send(:include, InstanceMethods)     
#       base.class_eval do
#         alias_method_chain :user_settings, :name
#       end
#     end

#     module InstanceMethods    
#       def user_settings_with_name(user)
#         user.firstname << " " << user.lastname
#         p '____________________________________lalala'
#       end
#     end
#   end
# end

# ApplicationHelper.send(:include, StaffsHelper::UsersHelperPatch)
