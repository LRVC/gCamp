class RegistrationsController < PublicController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user).permit(:first_name, :last_name, :email, :password))
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_project_path, notice: "You have successfully signed up"
    else
      render :new
    end
  end
end
