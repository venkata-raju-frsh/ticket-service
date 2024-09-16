# frozen_string_literal: true

module SecurityController
  extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!
    before_action :set_current_user
  end

  ADMIN = "ADMIN"
  AGENT = "AGENT"
  REGULAR = "REGULAR"
  def set_current_user
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
    @current_user_id = jwt_payload['sub']
    @current_user = User.find(@current_user_id)
    @current_user_roles = @current_user.user_roles.map(&:name)
  end

  def isAdmin?
    @current_user_roles.include?(ADMIN)
  end

  def isAgent?
    @current_user_roles.include?(AGENT)
  end

  def isRegular?
    @current_user_roles.include?(REGULAR) && !@current_user_roles.include?(ADMIN) && !@current_user_roles.include?(AGENT)
  end
end
