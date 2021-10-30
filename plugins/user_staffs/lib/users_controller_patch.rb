require_dependency 'users_controller'

module UsersControllerPatch

  def new
    super
    @provinces = Province.where(code: ["1", "79"])
    @departments = Department.all
    @centers = Center.all
    @job_positions = JobPosition.all
  end

  def create
    super
    @user.update(user_params)
  end

  def edit
    super
    @provinces = Province.where(code: ["1", "79"])
    @departments = Department.all
    @centers = Center.all
    @job_positions = JobPosition.all
    p "=========================================="
    
  end

  def update
    super
    p user_params
    p "=========================================="

    @user.update(user_params)
  end

  private
  def user_params
    params.require(:user).permit(
      :login, :firstname, :lastname, :mail,
      :language, :admin, :password, :password_confirmation, :generate_password, :must_change_passwd, :mail_notification, :notified_project_ids, 
      :another_email, :phone, :location_id, :birthday, :sex, :active_kpi,
      :active_bug, :department_id, :center_id, :job_position_id
    )
  end

end
