require_dependency 'users_controller'

module UsersControllerPatch


  def new
    super
    @provinces = Province.all

  end

  def create
    super
    byebug
    @user.update(user_params)
    p @user
  end

  def edit
    super
    @provinces = Province.all
    @departments = Department.all
    @centers = Center.all
    p @provinces
    p @user.province_id
    p "=========================================="
    
  end

  def update
    super
    p @user.province_id
    p "=========================================="

    @user.update(user_params)
  end

  private
  def user_params
    params.require(:user).permit(
      :login, :firstname, :lastname, :mail,
      :language, :admin, :password, :password_confirmation, :generate_password, :must_change_passwd, :mail_notification, :notified_project_ids, 
      :another_email, :phone,:province_id, :birthday, :sex, :active_kpi,
      :active_bug, :department_id
    )
  end


end
