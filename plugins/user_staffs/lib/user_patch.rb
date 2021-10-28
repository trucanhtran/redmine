module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      belongs_to :province

    end


  end

  module InstanceMethods
  end
end