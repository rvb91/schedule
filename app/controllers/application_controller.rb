class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :default_type])
    end

    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path

      case resource.default_type
      when "nanny"
        slots_path
      when "family"
        nannies_path
      end
    end
end
