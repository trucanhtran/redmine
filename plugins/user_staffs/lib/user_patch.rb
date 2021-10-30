module UserPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      belongs_to :location
      belongs_to :department
      belongs_to :center
      belongs_to :job_position
      validate :validates_user_phone, on: [:create, :update]
    end
  end

  module InstanceMethods
    def validates_user_phone
      p "-------------------------------------------------------------"
      if phone.present? && (phone.to_s.size < 10 || phone.to_s.size > 15)
        p phone
        errors.add(:phone, "Can't save")
      end
    end
  end
end