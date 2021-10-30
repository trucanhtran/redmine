module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      belongs_to :location
      belongs_to :department
      belongs_to :center
      belongs_to :job_position
      # validate :validates_user_phone
    end

    # def validates_user_phone
    #   unless phone.present? && (phone > 10 && phone < 15)
    #     errors.add(:errors)
    #   end
    # end


  end

  module InstanceMethods
  end
end