class UsersController<ApplicationController
  
  before_action :check_current_user

  def index
    @user = User.all
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
    redirect_to users_path, notice: 'User was successfully deleted'
  end

  private

  def users_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def check_current_user
    if current_user

    else
      redirect_to sign_in_path, notice: "You must sign in"
    end
  end
end
