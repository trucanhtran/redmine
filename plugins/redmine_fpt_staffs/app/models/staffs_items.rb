class StaffsItems < ActiveRecord::Base
	attr_protected :id

	STATUS_LOCKED     = 0
  STATUS_ACTIVE     = 1
  scope :active, lambda { where(:status => STATUS_ACTIVE) }
  scope :login_center, lambda {
    unless User.current.admin?
      where(:id => Staff.current.center_id) 
    end
  }
end
