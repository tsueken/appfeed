class Users::SessionsController < ApplicationController

  def new
    if current_user
      redirect_to root_path
    else
      @user = Users::LoginForm.new
    end
  end

  def create
    @user = Users::LoginForm.new(user_params)
    if @user.email.present?
      user = User.find_by(email: @user.email.downcase)
    end
    if Users::Authenticator.new(user).authenticate(@user.password)
      session[:user_id] = user.id
      redirect_to root_path
    else
      render action: "new"
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  private

    def user_params
      params.require(:users_login_form).permit(:email, :password)
    end

end
