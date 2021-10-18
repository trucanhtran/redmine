class Staff < ActiveRecord::Base

	# Account statuses
	STATUS_LOCKED     = 0
	STATUS_ACTIVE     = 1
	STATUS_REGISTERED = 2
	STATUS_ANONYMOUS  = 3

	belongs_to :user, :class_name => 'User'
	attr_protected :id

	before_validation :strip_blanks

	# validates_presence_of :identity_card, :center_id, :full_name, :start_date_contract, :start_date_company
	validates_format_of :mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
	validates_uniqueness_of :employee_id, :mail, :case_sensitive => false, #case_sensitive ko phan biet hoa thuong
		:if => Proc.new {|email| email.mail_changed? && email.mail.present?} #sau này có lấy data cũ nhập vào, bỏ qua nhập mail, update mail staff bằng query
	validate :validate_staff
	# validates :created_on, :date => true
	# validates :updated_on, :date => true
	validates :employee_id, :uniqueness => true, :allow_blank => true
	validates_uniqueness_of :identity_card, :uniqueness => true, conditions: -> { where(type_staff: 0) }
	validates :hardskill, :softskill, :achievement, :permanent_address, :temporary_address, :contact, :note, :job_code, :job_code_tmp, :updated_by, :certificate, length: { maximum: 255 }
	validates :employee_id , length: {maximum: 10}
	validates :full_name, :mail, :another_email, :place_birth, :phone, :identity_card, :identity_by, :ethnic,  length: {maximum: 50}

	scope :active, lambda { where(:status => STATUS_ACTIVE) }
	scope :sorted, lambda { order(*Staff.fields_for_order_statement)}
	scope :current, lambda {
		where(:user_id => User.current.id).first
	}

	include StaffsHelper

	def self.mail
		user.email_address.try(:address)
	end

	def self.mail_changed?
		user.email_address.try(:address_changed?).to_s
	end

	def strip_blanks
		self.employee_id = self.employee_id.strip unless self.employee_id.nil?
		self.identity_card = self.identity_card.strip unless self.identity_card.nil?
		self.phone = self.phone.strip unless self.phone.nil?
		self.mail = self.mail.strip unless self.mail.nil?
		self.full_name = self.full_name.strip unless self.full_name.nil?
		self.another_email = self.another_email.strip unless self.another_email.nil?
		if self.type_staff == 0
			validates_presence_of :identity_card, :center_id, :full_name, :start_date_contract, :start_date_company
		end
	end

	def validate_staff
		if new_record?
			unless check_permission(:create, department_id)
				errors.add :base, I18n.t(:error_can_not_permission_create, :department => find_name_option_by_id(department_id))
			end
			if active_kpi.to_i == 1
				unless check_permission(:active_kpi,department_id)
					errors.add :base, I18n.t(:error_can_not_permission_active_kpi, :department => find_name_option_by_id(department_id))
				end
			end

			if active_bug.to_i == 1
				unless check_permission(:active_bug, department_id) 
					errors.add :base, I18n.t(:error_can_not_permission_active_bug, :department => find_name_option_by_id(department_id))
				end
			end
			if phone.class != NilClass && phone != "" && (false if Float(phone) rescue true)
				errors.add :base, I18n.t(:error_must_be_number, :option => "Phone")
			end
			if employee_id.class != NilClass && employee_id != "" && (false if Float(employee_id) rescue true)
				errors.add :base, I18n.t(:error_must_be_number, :option => "Mã nhân viên")
			end
			if type_staff == 0 && identity_card.class != NilClass && identity_card != "" && (false if Float(identity_card) rescue true)
				errors.add :base, I18n.t(:error_must_be_number, :option => "CMND")
			end
			if work_id or start_date_off or end_date_off
				if [10,11].include? work_id
					if start_date_off == nil or end_date_off == nil
						if start_date_off == nil
							errors.add :base, I18n.t(:error_dateoff, :option => "Ngày bắt đầu nghỉ tạm (Từ)")
						end
						if end_date_off == nil
							errors.add :base, I18n.t(:error_dateoff, :option => "Ngày kết thúc nghỉ tạm (Đến)")
						end
					else
						if start_date_off > end_date_off
							errors.add :base, I18n.t(:error_startdateoff_not_smaller_than_enddateoff)
						end
					end
				elsif [12,13,14,15,46].include? work_id
					if start_date_off == nil
						errors.add :base, I18n.t(:error_dateoff, :option => "Ngày bắt đầu nghỉ việc (Từ)")
					end
				end
			end
			if start_date_contract and due_date_contract
				if start_date_contract > due_date_contract
					errors.add :base, I18n.t(:error_startdatecontract_not_smaller_than_enddatecontract)
				end
				# if contract_id == 4
				# 	if due_date_contract != start_date_contract + 12.months
				# 		errors.add :base, I18n.t(:error_date_contract_not_enough)
				# 	end
				# end
				# if contract_id == 5
				# 	if (due_date_contract < start_date_contract + 12.months) or (due_date_contract > start_date_contract + 36.months)
				# 		errors.add :base, I18n.t(:error_date_contract_not_enough)
				# 	end
				# end
			end
		else
			unless check_permission(:edit, department_id)
				errors.add :base, I18n.t(:error_can_not_permission_edit, :department => find_name_option_by_id(department_id))
			end
			if active_kpi_changed?
				unless check_permission(:active_kpi,department_id)
					errors.add :base, I18n.t(:error_can_not_permission_active_kpi, :department => find_name_option_by_id(department_id))
				else
					if user_id
						user_kpi = CustomValue.where(:customized_id => user_id, :custom_field_id => 163).first
						CustomValue.update(user_kpi.id, {value: active_kpi})
					end
				end
			end
			if active_bug_changed?
				unless check_permission(:active_bug, department_id) && active_bug_changed?
					errors.add :base, I18n.t(:error_can_not_permission_active_bug, :department => find_name_option_by_id(department_id))
				else
					if user_id
						user_bug = CustomValue.where(:customized_id => user_id, :custom_field_id => 162).first
						CustomValue.update(user_bug.id, {value: active_bug})
					end
				end
			end
			if user_id_changed?
				user_kpi = CustomValue.where(:customized_id => user_id, :custom_field_id => 163).first
				if user_kpi.value.to_i != active_kpi
					CustomValue.update(user_kpi.id, {value: active_kpi})
				end
				user_bug = CustomValue.where(:customized_id => user_id, :custom_field_id => 162).first
				if user_bug.value.to_i != active_bug
					CustomValue.update(user_bug.id, {value: active_bug})
				end
			end
			if job_code_tmp_changed?
				if user_id && (!job_code || job_code == '')
					user_job_code = CustomValue.where(:customized_id => user_id, :custom_field_id => 160).first
					CustomValue.update(user_job_code.id, {value: job_code_tmp})
				end
			end
			if job_code_changed?
				if user_id
					user_job_code = CustomValue.where(:customized_id => user_id, :custom_field_id => 160).first
					CustomValue.update(user_job_code.id, {value: job_code})
				end
			end
			if phone_changed?
				if phone.class != NilClass && phone != "" && (false if Float(phone) rescue true)
					errors.add :base, I18n.t(:error_must_be_number, :option => "Phone")
				end
			end
			if employee_id_changed?
				if employee_id.class != NilClass && employee_id != "" && (false if Float(employee_id) rescue true)
					errors.add :base, I18n.t(:error_must_be_number, :option => "Mã nhân viên")
				end
			end
			if identity_card_changed?
				if type_staff == 0 && identity_card.class != NilClass && identity_card != "" && (false if Float(identity_card) rescue true)
					errors.add :base, I18n.t(:error_must_be_number, :option => "CMND")
				end
			end
			if work_id_changed? or start_date_off_changed? or end_date_off_changed?
				if [10,11].include? work_id
					if start_date_off == nil or end_date_off == nil
						if start_date_off == nil
							errors.add :base, I18n.t(:error_dateoff, :option => "Ngày bắt đầu nghỉ tạm (Từ)")
						end
						if end_date_off == nil
							errors.add :base, I18n.t(:error_dateoff, :option => "Ngày kết thúc nghỉ tạm (Đến)")
						end
					else
						if start_date_off > end_date_off
							errors.add :base, I18n.t(:error_startdateoff_not_smaller_than_enddateoff)
						end
					end
				elsif [12,13,14,15,46].include? work_id
					if start_date_off == nil
						errors.add :base, I18n.t(:error_dateoff, :option => "Ngày bắt đầu nghỉ việc (Từ)")
					end
				end
			end
			if (start_date_contract and due_date_contract) and (start_date_contract_changed? or due_date_contract_changed?)
				if start_date_contract > due_date_contract
					errors.add :base, I18n.t(:error_startdatecontract_not_smaller_than_enddatecontract)
				end
				# if contract_id == 4
				# 	if due_date_contract != (start_date_contract + 12.months)
				# 		errors.add :base, I18n.t(:error_date_contract_not_enough)
				# 	end
				# end
				# if contract_id == 5
				# 	if (due_date_contract < start_date_contract + 12.months) or (due_date_contract > start_date_contract + 36.months)
				# 		errors.add :base, I18n.t(:error_date_contract_not_enough)
				# 	end
				# end
			end
		end
	end

	def self.fields_for_order_statement(table=nil)
		table ||= table_name
		columns = ['type DESC']
		columns.uniq.map {|field| "#{table}.#{field}"}
	end

end
