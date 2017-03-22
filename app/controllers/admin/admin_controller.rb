module Admin
  # top-level class documentation comment
  class AdminController < ActionController::Base
    layout 'admin_panel'

    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :verify_admin

    def not_found
      render file: 'public/404.html', status: :not_found, layout: false
    end 

    private

    def verify_admin
      role = current_user.try('role')
      if role.try('name') != 'admin'
        redirect_to root_url,
                    notice: 'Недостатньо прав для здійснення даної дії'
      end
    end
  end
end
