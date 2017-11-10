class UsersController < ApplicationController
  before_action :set_user, except: %i(index new create)
  before_action :load_user, only: %i(show following)
  attr_accessor :remember_token

  def index
    @users = User.all
  end

  def new
    @user = User.new
    respond_to do |format|
      format.js
    end
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t ".User was successfully created"
      redirect_to @user
    else
      flash[:danger] = t ".Sign up error"
      redirect_to root_path
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update user_params
        format.html {redirect_to @user,
          notice: t(".User was successfully updated.")}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html {redirect_to users_url,
        notice: t(".User was successfully destroyed")}
    end
  end

  def following
    @users = @user.following
  end

  def followers
    @users = @user.followers
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
  end

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
