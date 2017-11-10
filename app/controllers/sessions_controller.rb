class SessionsController < ApplicationController
  def new
    respond_to do |format|
      format.js
    end
  end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == 1 ? remember(user) : forget(user)
      redirect_to user
    else
      flash[:danger] = t ".Invalid email/password combination"
      redirect_to root_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
