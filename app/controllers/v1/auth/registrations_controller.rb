class V1::Auth::RegistrationsController < ApplicationController
  def create
    @user = User.new sign_up_params
    if @user.save
      return render_success_user_created
    else
      return render_error_user_save
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

  def render_error_user_save
    render status: :unprocessable_entity, json: {errors: @user.errors.full_messages}
  end
end
