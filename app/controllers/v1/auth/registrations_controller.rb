class V1::Auth::RegistrationsController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]

  def create
    @user = User.new sign_up_params
    if @user.save
      return render_success_user_created
    else
      return render_error_save :unprocessable_entity, @user
    end
  end

  def destroy
    current_user.destroy!
    return render_success_user_destroyed
  end

  private

  def sign_up_params
    params.permit(:name, :username, :email, :password)
  end

  protected

  def render_success_user_created
    render status: :created, template: 'auth/sign_up.json.jbuilder'
  end

  def render_success_user_destroyed
    render status: :no_content, json: {}
  end
end
