class SessionsController < ApplicationController
  # skip_before_action :require_user
  # skip_before_action :require_admin

  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = ""
      redirect_to dashboard_path
      # if current_admin?
      #   # redirect_to '/admin/dashboard'
      # else
      #   # redirect_to '/dashboard'
      # end
    else
      render :new
    end
  end

  def new
  end

  def destroy
    session.clear
    flash[:success] = 'Successfully logged out!'
    redirect_to login_path
  end

end
