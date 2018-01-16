class ApplicationController < ActionController::API

  helper_method :set_headers!
  helper_method :remove_headers!
  helper_method :req_params_present?
  helper_method :render_error_save
  helper_method :render_error_add

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
  def render_error_save obj
    render status: :unprocessable_entity, json: {errors: obj.errors.full_messages}
  end

  # returns error from language
  def render_error_add string
    render status: :unprocessable_entity, json: {errors: [I18n.t("error.#{string}")]}
  end
end
