class UsersController<ApplicationController

  before_action :check_current_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(users_params)
     if @user.save
       redirect_to users_path, notice: 'User was successfully created.'
     else
       render :new
     end

  end

  def show

    @user = User.find(params[:id])
    user = @user
  end

  def edit
    @user = User.find(params[:id])
    unless current_user.id == @user.id || current_user.admin
      raise AccessDenied
    end
  end

  def update
    @user = User.find(params[:id])

    if  @user.update(users_params)
        redirect_to users_path, notice: 'User was successfully updated'
    else
        render :edit
    end

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to users_path, notice: 'User was successfully deleted'
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :admin)
  end

  def check_current_user
    if current_user

    else
      session[:redirect_to] = request.fullpath
      redirect_to sign_in_path, alert: "You must sign in"
    end
  end
end
