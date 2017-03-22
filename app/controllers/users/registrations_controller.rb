module Users
  class RegistrationsController < Devise::RegistrationsController
    include ApplicationHelper

    before_action :delete_avatar, only: :update

    respond_to :html, :js

    def valid_avatar
      @avatar = User.new(avatar: params[:avatar])
      @avatar.avatar_validator

      respond_to do |format|
        if @avatar.valid?
          format.json do
            render 'devise/registrations/valid',
                   json: nil, status: :ok
          end
        else
          format.json do
            render 'devise/registrations/valid',
                   json: { errors: get_error_messages(@avatar) },
                   status: :unprocessable_entity
          end
        end
      end
    end

    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      respond_to do |format|
        if resource.persisted?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          format.js do
            redirect_to edit_user_registration_path,
                        notice: 'Ласкаво просимо! Ви успішно зареєструвалися.'
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          format.js { render :create }
        end
      end
    end

    def delete_avatar
      resource.avatar.try(:destroy) && resource.save if params[:drop_file]
    end
  end
end
