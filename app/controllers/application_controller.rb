class ApplicationController < ActionController::API

  helper_method :set_headers!
  helper_method :remove_headers!
  helper_method :req_params_present?
  helper_method :render_error_save
  helper_method :render_error_add
  helper_method :user_signed_in?
  helper_method :current_user

  private

  # set session in headers
  def set_headers! session = nil
    response.headers['sid'] = session.id
    response.headers['utoken'] = session.utoken
  end

  # checks if required params all present?
  def req_params_present? sym_array = []
    return sym_array.all? {|k| params.has_key? k}
  end

  # remove session in headers
  def remove_headers!
    response.headers['sid'] = nil
    response.headers['utoken'] = nil
  end

  # returns errors in object
  def render_error_save status = :unprocessable_entity, obj
    render status: status, json: {errors: obj.errors.full_messages}
  end

  # returns error from language
  def render_error_add status = :unprocessable_entity, string
    render status: status, json: {errors: [I18n.t("error.#{string}")]}
  end

  # authenticates if user present
  def authenticate_user!
    if request.headers['sid'].present? && !request.headers['sid'].nil? && request.headers['utoken'].present? && !request.headers['utoken'].nil?
      session = Session.active_sessions.find_by_id(request.headers['sid'])
      if session.nil? || session.utoken != request.headers['utoken']
        render_error_add :unauthorized, 'unauthorized' and return
      end
    else
      render_error_add :unauthorized, 'unauthorized' and return
    end
  end

  # Question whether user signed in or not
  def user_signed_in?
    if request.headers['sid'].present? && !request.headers['sid'].nil? && request.headers['utoken'].present? && !request.headers['utoken'].nil?
      if Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).nil?
        return false
      else
        return true
      end
    else
      return false
    end
  end

  # Return current signed in user
  def current_user
    if user_signed_in?
      Session.active_sessions.find_by(id: request.headers['sid'], utoken: request.headers['utoken']).user
    else
      nil
    end
  end
end
