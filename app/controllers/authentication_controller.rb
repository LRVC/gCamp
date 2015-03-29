class AuthenticationController < PublicController


  def new

  end

  def create
    user = User.find_by(email: (params[:email]))
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if session[:redirect_to] == nil
        redirect_to root_path
      else
        redirect_to session[:redirect_to], notice: "You have signed in successfully"
      end
    else
      @sign_in_error = "Email/Password combination is invalid"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have successfully logged out"
  end

end
