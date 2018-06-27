class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from StandardError, :with => :render_error

  def render_error(exception)
    render template: 'errors/show'
  end

  protected
    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
end
