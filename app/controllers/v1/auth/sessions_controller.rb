class V1::Auth::SessionsController < ApplicationController

  before_action :authenticate_user!, only: %i[destroy]

  def create
    return render_error_add :unprocessable_entity, 'params_absent' unless req_params_present? [:auth, :password]
    @user = User.find_by(username: sign_in_params[:auth])
    @user = User.find_by(email: sign_in_params[:auth]) if @user.nil?
    if @user.nil?
      return render_error_add :unprocessable_entity, 'auth.user_not_found'
    elsif !@user.authenticate(sign_in_params[:password])
      return render_error_add :unprocessable_entity, 'auth.user_not_found'
    end
    @session = @user.sessions.build
    if @session.save
      set_headers! @session
      return render_success_session_created
    else
      return render_error_save :unprocessable_entity, @session
    end
  end

  def destroy
    Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).update(active: false)
    remove_headers!
    return render_success_session_destroyed
  end

  private

  def sign_in_params
    params.permit(:auth, :password)
  end

  protected

  def render_success_session_created
    render status: :created, template: 'auth/sign_in.json.jbuilder'
  end

  def render_success_session_destroyed
    render status: :no_content, json: {}
  end
end
