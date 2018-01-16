class V1::Auth::RegistrationsController < ApplicationController
  def create
    @user = User.new sign_up_params
    if @user.save
      return render_success_user_created
    else
      return render_error_save :unprocessable_entity, @user
    end
  end

  private

  def sign_up_params
    params.permit(:name, :username, :email, :password)
  end

  protected

  def render_success_user_created
    render status: :created, template: 'auth/sign_up.json.jbuilder'
  end
end
