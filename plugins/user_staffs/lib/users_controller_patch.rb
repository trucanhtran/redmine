require_dependency 'users_controller'

module UsersControllerPatch

  def new
    init_data
    super
  end

  def create
    init_data
    super
    # Attachment.attach_files(@user, params[:attachments])
    @user.update(user_params)
    byebug
    @user.save_attachments(params[:attachments]) 
    @user.save
  end

  def edit
    init_data
    super
    
  end

  def update
    init_data
    super
    p user_params

    @user.update(user_params)
    byebug
    @user.save_attachments(params[:attachments])

  end

  def display_districts
    province = Province.find_by(id: params[:place_id])
    districts = province.districts
    render json: districts
  end

  def display_wards
    district = District.find_by(id: params[:place_id])
    wards = district.wards
    render json: wards
  end

  def display_input
  end

   private
  def user_params
    params.require(:user).permit(
      :login, :firstname, :lastname, :mail,
      :language, :admin, :password, :password_confirmation, :generate_password, :must_change_passwd, :mail_notification, :notified_project_ids, 
      :another_email, :phone, :location_id, :birthday, :sex, :active_kpi,
      :active_bug, :department_id, :center_id, :job_position_id, :permanent_address,
      :hardskill, :softskill, :achievement, :start_date_company, :start_date_contract,
      :due_date_contract, :start_date_off, :place_birth, :permanent_address,
      :temporary_address, :identity_card, :identity_date, :identity_by, :ethnic, :contact,
      :note, :avatar, :contract_id, :work_id, :team_leader
    )
  end

  def init_data
    @locations = Province.joins(:location).select("provinces.name as name, locations.id as id")
    @job_positions = JobPosition.all
    @contracts = Contract.all
    @works = Work.all
    @departments = Department.all
    @centers = Center.all
    @team_leaders = ['ANT54', 'ThanhTC21', 'CuongDD14']
    @provinces = Province.all
    @districts = District.all
    @wards = Ward.all
    @place_births = Province.all
  end

end
