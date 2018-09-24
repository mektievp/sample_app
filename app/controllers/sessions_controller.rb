class SessionsController < ApplicationController
  def new
  end

  def create
    # This is an instance variable so that we can access it from inside a test
    # using 'assigns'.
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      # rails automatically convert this to redirect_to user_url(user)
      # If a session[:forwarding_url] is defined, this is where the user gets
      # redirected to upon successful login. If not defined, then user gets
      # redirected to his profile page.
    else
      flash.now[:danger] = 'Invalid email/password combination.'
      render 'new' # renders the new view i.e. new.html.erb
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
