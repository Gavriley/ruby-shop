# top-level class documentation comment
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  rescue_from CanCan::AccessDenied,
              with: -> {
                      redirect_to root_url,
                                  notice: 'Недостатньо прав для здійснення даної дії'
                    }

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action { @categories = Category.parent_categories }

  before_action :verify_admin

  def not_found
    @title = 'Page Not Found'
    render 'layouts/404', layout: 'application'
  end

  protected

  def verify_admin
    role = current_user.try('role')

    @admin = if role.try('name') == 'admin'
               true
             else
               false
             end
  end

  def configure_permitted_parameters
    added_attrs = [:login, :email, :name, :password,
                   :password_confirmation,
                   :avatar, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
