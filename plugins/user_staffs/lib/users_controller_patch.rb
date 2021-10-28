require_dependency 'users_controller'

module UsersControllerPatch


  def new
    super
    @provinces = Province.all

  end

  def create
    super
    @provinces = Province.all
    @user.create(user_params)
  end

  def edit
    super
    @provinces = Province.all
    
  end

  def update
    super
    @user.update(user_params)
  end

  private
  def user_params
    params.require(:user).permit(:another_email, :phone, :birthday, :sex, :province_id, :active_kpi,
      :active_bug, :adress, :location, :department, :type, :position, :team)
  end


end
