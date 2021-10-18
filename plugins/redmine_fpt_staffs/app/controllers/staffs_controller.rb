require 'caxlsx_rails'
class StaffsController < ApplicationController
  self.main_menu = false
  before_action :permissions, :only => [:index, :edit, :create, :new, :dashboard]
  before_action :find_staff,  :only => [:edit, :destroy]
  before_action :find_user,  :only => [:create, :update]
  before_action :authorize_global, :only => [:destroy]

  rescue_from Query::StatementInvalid, :with => :query_statement_invalid

  helper :staffs
  include StaffsHelper
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper

  require_sudo_mode :create, :update, :destroy
  
  def index

    retrieve_query(StaffQuery)

    if @query.valid?
      respond_to do |format|
        format.html {
          @staff_count = @query.staff_count
          @staff_pages = Paginator.new @staff_count, per_page_option, params['page']
          @staffs = @query.staffs(:offset => @staff_pages.offset, :limit => @staff_pages.per_page)
          render :layout => !request.xhr?
        }
        format.api  {
          @offset, @limit = api_offset_and_limit
          @staff_count = @query.staff_count
          @staffs = @query.staffs(:offset => @offset, :limit => @limit)
        }
        format.pdf  {
          @staffs = @query.staffs
          send_file_headers! :type => 'application/pdf', :filename => Time.now.strftime("%Y%m%d") + "_Staffs.pdf"
        }
        format.xls {
          @staffs = @query.staffs
          staffs = staffs_to_excel(@staffs, @query)
          export_to_xlsx staffs
        }
      end
    else
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
        format.any(:atom, :csv, :pdf) { head 422 }
        format.api { render_validation_errors(@query) }
      end
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  def show
  end

  def dashboard
    retrieve_query(StaffDashboardQuery)
    if @query.valid?
      respond_to do |format|
        format.html {
          @time = @query.params_statement
          # @staffs = @query.staffs
          render :layout => !request.xhr?
        }
        format.js {
          @time = @query.params_statement
        }
      end
    end
  end

  def new
    @auth_sources = AuthSource.all
    if params[:copy_from].present?
      @staff = Staff.find(params[:copy_from]).dup
    else 
      @staff = Staff.new
    end
  end

  def create
    @error_user = '' 
    @staff = Staff.new(staff_params)
    staff_login(:new)
    if @error_user.empty?
      if @staff.save
        if @user.save
          @staff.update_attributes(:user_id => @user.id)
          user_job_code = CustomValue.where(:customized_id => @user.id, :custom_field_id => 160).first
          CustomValue.update(user_job_code.id, {value: @staff.job_code_tmp})
        end
        if @staff.employee_id == ''
          @staff.update_attributes(:employee_id => nil)
        end
        respond_to do |format|
          format.html {
            flash[:notice] = l(:notice_staff_successful_create, :id => staff_path(@staff))
            if params[:continue]
              attrs = params[:staff]
              redirect_to new_staff_path(:staff => attrs)
            else
              redirect_to staffs_path
            end
          }
          format.api  { render :action => 'index'}
        end
      else
        respond_to do |format|
          format.html { render :action => 'new' }
          format.api  { render_validation_errors(@staff) }
        end
      end
    end
  end

  def edit
  end

  def update
    @error_user = '' 
    @staff = Staff.find(params[:id])
    staff_login(:edit)

    if @error_user.empty?
      if @staff.update_attributes(staff_params)
        @staff.update_attributes(:user_id => @user.id) if @user.save
        if @staff.employee_id == ''
          @staff.update_attributes(:employee_id => nil)
        end
        work_id = staff_params["work_id"].to_i
        if [12,13,14,15,46].include? work_id
          @staff.update_attributes(:end_date_off => nil)
        elsif work_id == 9
          @staff.update_attributes(start_date_off: nil, end_date_off: nil)
        end
        respond_to do |format|
          format.html {
            flash[:notice] = l(:notice_successful_update)
            redirect_back_or_default staffs_path
          }
          format.api  { render_api_ok }
        end
      else
        respond_to do |format|
          format.html { render :action => 'edit' }
          format.api  { render_validation_errors(@staff) }
        end
      end
    end
  end

  def destroy
    destroyed = @staff.destroy
    if destroyed
      user = User.find_by_id(@staff.user_id)
      if user.present?
        staffs_setting = StaffsSettings.find_by_user_id(user.id)
        if !staffs_setting.nil?
          staffs_setting.destroy
        end
        user.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_back_or_default(staffs_path) }
      format.api  { render_api_ok }
    end
    respond_to do |format|
      format.html {
        if destroyed
          flash[:notice] = l(:notice_successful_delete)
        else
          flash[:error] = l(:notice_unable_delete_time_entry)
        end
      }
      format.api  { render_api_ok }
    end
  end

  def change_center
    respond_to do |format|
      format.js
    end
  end

  def change_department
    respond_to do |format|
      format.js
    end
  end

  def change_team_leader
    @staff = Staff.find(params[:id])
    @check = @staff.update_attributes({:team_leader => params['team_leader']})
    # Staff.update(params[:id], {team_leader: params[:team_leader]})
    respond_to do |format|
      format.js
    end
  end

  def filter
    q = Query.get_subclass(params[:type] || 'IssueQuery').new

    filter = q.available_filters[params[:name].to_s]
    values = filter ? filter.values : []

    render :json => values
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  private
    def staff_params
      allow = [
        :id,
        :user_id,
        :employee_id,
        :full_name,
        :mail,
        :another_email,
        :sex,:birthday,
        :place_birth,
        :phone,:identity_card,
        :identity_date,
        :identity_by,
        :ethnic,
        :permanent_address,
        :temporary_address,
        :contact,:note,
        :start_date_company,
        :start_date_contract,
        :start_date_off,
        :end_date_off,
        :due_date_contract,
        :active_kpi,
        :active_bug,
        :location_id,
        :department_id,
        :position_id,
        :contract_id,
        :status,
        :work_id,
        :center_id,
        :job_code,
        :job_code_tmp,
        :job_title_id,
        :job_position_id,
        :certificate,
        :degree_id,
        :hardskill,
        :softskill,
        :achievement,
        :staff_avatar,
        :team_leader,
        :type_staff
      ]
      params.require(:staff).permit(allow)
    end
    def find_staff
      @staff = Staff.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
    def require_admin
      return unless require_login
      if !User.current.admin?
        render_403
        return false
      end
      true
    end

    def permissions(action = params[:action])
      staffs_settings_permissions(action)
    end

    def find_user
      @user = nil
      if params[:action] == 'create'
        @user = User.new(
          :language => Setting.default_language, 
          :mail_notification => Setting.default_notification_option, 
          :admin => false, 
          :must_change_passwd => false, 
          :status => 1,
          :auth_source_id => 1, #login mail fpt
        )
      else
        @user = Staff.find_by_id(params[:id]).user()
        if @user.blank?
          @user = User.new(
          :language => Setting.default_language, 
          :mail_notification => Setting.default_notification_option, 
          :admin => false, 
          :must_change_passwd => false, 
          :status => 1,
          :auth_source_id => 1, #login mail fpt
        )
        end
      end
    end

    def staff_login(action)
      if action.to_s == "edit" && staff_params[:mail].blank? && !@staff.user.nil?
        user = User.find_by_id(@staff.user.id)
        staffs_setting = StaffsSettings.find_by_user_id(@staff.user.id)
        staffs_setting.destroy unless staffs_setting.nil?
        user.destroy unless user.nil?
        staff = Staff.find_by_id(params[:id])
        staff.update_attribute :user_id, nil
      end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
      if !staff_params[:mail].blank? && !@user.nil? #&& @staff.job_code.nil?
        @user.mail = staff_params[:mail].to_s
        staff_name = staff_params[:full_name].split(' ')
        @user.firstname = staff_params[:full_name].sub(staff_name[staff_name.count-1],"").strip
        @user.lastname = staff_name[staff_name.count-1]
        # @user.job_code = "DEV02"
        @user.login = staff_params[:mail].split('@').first.to_s
        if !@user.valid?
          @error_user = @user.errors.full_messages.flatten.uniq.join(', ')
          @staff.errors.add(:User, @error_user)
          respond_to do |format|
            format.html { render :action => action }
            format.api  { render_validation_errors(@staff) }
          end
        end
      end
    end

    def export_to_xlsx(file)
      tempfile = "#{Rails.root}/tmp/staffs_tempfile.xlsx"
      file_name = Time.now.strftime("%Y%m%d") + "_Staffs.xlsx"
      file.serialize tempfile
      File.open tempfile, "r" do |f|
        send_data f.read, filename: file_name, type: "application/xlsx"
      end
      File.delete tempfile
    end
end
