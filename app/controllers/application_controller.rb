# top-level class documentation comment
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  rescue_from CanCan::AccessDenied, with: :access_denied
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action { @categories = Category.parent_categories }
  before_action :verify_admin
  before_action :set_locale

  def not_found
    render file: 'public/404.html', status: :not_found, layout: false
  end  

  protected

  def set_locale
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        raise ActiveRecord::RecordNotFound
      end  
    end  
  end  

  def verify_admin
    role = current_user.try('role')
    role_name = role.try('name')
    @admin = role_name == 'admin'
  end

  def configure_permitted_parameters
    added_attrs = [:login, :email, :name, :password,
                   :password_confirmation,
                   :avatar, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def access_denied
    redirect_to root_url, notice: 'Недостатньо прав для здійснення даної дії'
  end  
end
