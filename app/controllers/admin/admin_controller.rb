module Admin
  # top-level class documentation comment
  class AdminController < ActionController::Base
    layout 'admin_panel'

    protect_from_forgery with: :exception

    rescue_from ActiveRecord::RecordNotFound,
                with: -> { redirect_to admin_root_path }

    before_action :verify_admin

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
