class StaffsSettingsController < ApplicationController
	# model_object StaffsSettings
	# before_action :find_model_object, :except => [:autocomplete]
  before_action :find_staffs_settings, :only => [:edit,:destroy]

  # require_sudo_mode :create, :update, :destroy

  layout 'admin'
  helper :staffs
  helper :queries
  include QueriesHelper
  helper :sort
  include SortHelper
  
  def new
  	@staffs_settings = StaffsSettings.new
  end

  def create
    staffs_settings = []
    if params[:staffs_settings]
      user_ids = Array.wrap(params[:staffs_settings][:user_ids])
      user_ids << nil if user_ids.empty?
      user_ids.each do |user_id|
        staffs_setting = StaffsSettings.new(:user_id => user_id)
        staffs_setting.center_id = !params[:staffs_settings][:center_id] ? nil : params[:staffs_settings][:center_id]
        staffs_setting.view = set_editable_department_ids(params[:staffs_settings][:view])
        staffs_setting.create = set_editable_department_ids(params[:staffs_settings][:create])
        staffs_setting.edit = set_editable_department_ids(params[:staffs_settings][:edit])
        staffs_setting.active_kpi = set_editable_department_ids(params[:staffs_settings][:active_kpi])
        staffs_setting.active_bug = set_editable_department_ids(params[:staffs_settings][:active_bug])
        staffs_settings << staffs_setting
      end
    end
    @errors = ''
    staffs_settings.each do |manager|
      @staffs_setting = StaffsSettings.new
      @staffs_setting = manager
      if !@staffs_setting.valid?
        @errors = @staffs_setting.errors.full_messages.flatten.uniq.join(', ')
      end
    end

    if @errors == ''
      staffs_settings.each do |manager|
        manager.save
      end
    end
    retrieve_query(StaffsSettingsQuery)
    if @query.valid?
      respond_to do |format|
        format.js {
          @staffs_settings_count = @query.staffs_settings_count
          @staffs_settings_pages = Paginator.new @staffs_settings_count, per_page_option, params['page']
          @staffs_settings = @query.staffs_settings(:offset => @staffs_settings_pages.offset, :limit => @staffs_settings_pages.per_page)
      }
      end
    end

  end

  def index
    retrieve_query(StaffsSettingsQuery)

    if @query.valid?
      respond_to do |format|
        format.html {
          @staffs_settings_count = @query.staffs_settings_count
          @staffs_settings_pages = Paginator.new @staffs_settings_count, per_page_option, params['page']
          @staffs_settings = StaffsSettings.joins(:user)
          @staffs_settings = @staffs_settings.like("#{params[:name]}") if params[:name].present?
          @staffs_settings.offset(@staffs_settings_pages.offset).limit(@staffs_settings_pages.per_page)
          render :layout => !request.xhr?
        }
      end
    else  
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
        format.any(:atom, :csv, :pdf) { head 422 }
        format.api { render_validation_errors(@query) }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @staffs_settings = StaffsSettings.find(params[:id])
    @staffs_settings.view = set_editable_department_ids(params[:staffs_settings][:view])
    @staffs_settings.create = set_editable_department_ids(params[:staffs_settings][:create])
    @staffs_settings.edit = set_editable_department_ids(params[:staffs_settings][:edit])
    @staffs_settings.active_kpi = set_editable_department_ids(params[:staffs_settings][:active_kpi])
    @staffs_settings.active_bug = set_editable_department_ids(params[:staffs_settings][:active_bug])
    if @staffs_settings.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default staffs_settings_path
        }
        format.api  { render_api_ok }
      end
    else
      error = @staffs_settings.errors.full_messages.flatten.uniq.join(', ')
      respond_to do |format|
        format.html { 
          flash[:error] = l(:notice_failed_to_save_staffs_settings, :name => @staffs_settings.user.name.capitalize, :errors => error) 
          redirect_back_or_default(staffs_settings_path)
        }
      end
    end
  end

  def destroy
    destroyed = @staffs_settings.destroy
    respond_to do |format|
      format.html { redirect_back_or_default(staffs_settings_path) }
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

  def autocomplete
    respond_to do |format|
      format.js
    end
  end

  def change_center
    respond_to do |format|
      format.js
    end
  end

  private

    def find_staffs_settings
      @staffs_settings = StaffsSettings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
    def set_editable_department_ids(ids)
      ids = (ids || []).collect(&:to_s)
    end
end
