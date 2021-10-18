class StaffsSettings < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :dependent => :destroy
  serialize :view #serialize save Array 
  serialize :create 
  serialize :edit 
  serialize :active_kpi 
	serialize :active_bug 
	attr_reader :id
	# validates :department_id, presence: true
	validates :user_id, :center_id, presence: true

  scope :like, lambda { |str|
    where("users.login like '#{str}%' ") 
  }

  def self.check_view_menu_top
    return true if User.current.name == 'admin'
    settings = StaffsSettings.where(" user_id = #{User.current.id}").pluck(:view).first
    if settings.present?
      true
    else
      false
    end
  end
end
