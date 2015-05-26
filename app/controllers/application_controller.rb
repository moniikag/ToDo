class ApplicationController < ActionController::Base

  include Authenticate
  before_action :authenticate_user

  include Pundit
  after_action :verify_authorized
  protect_from_forgery with: :exception

end
