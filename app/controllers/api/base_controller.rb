class Api::BaseController < ActionController::API
  before_action :doorkeeper_authorize!, :authenticate_user, unless: [:signing_in]
  respond_to :json

  rescue_from Mongoid::Errors::DocumentNotFound, with: :not_found
  rescue_from ::ActionController::RoutingError, with: :not_found
  rescue_from ::ActionController::UnknownFormat, with: :not_found
  # rescue_from ::ActionController::UnknownController, with: :not_found

  def api_error(status, errors)
    render json: {status: status, errors: errors, message: errors}
  end

  def not_found
    return api_error(404, 'Resource not found')
  end

  def authenticate_user
    if current_user.nil? and params[:access_token].present?
      api_error(401, 'invalid access token.')
      return
    end
  end

  private

    def current_token
      Doorkeeper::AccessToken.find_by(token: params[:access_token]) rescue nil
    end

    def current_user
      User.find_by(id: current_token.resource_owner_id) rescue nil
    end

    def authorize_application
      @app = Doorkeeper::Application.find_by(uid: params[:client_id], secret: params[:client_secret])
      if @app.nil?
        return api_error(401, 'Unauthorized!')
      end
    end

    def signing_in
      return true if ["sign_in", "sign_up"].include?(params[:action]) and params[:controller] == "api/v1/users"
    end
end
