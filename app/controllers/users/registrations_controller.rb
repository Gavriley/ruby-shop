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

    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]

    # GET /resource/sign_up
    # def new
    #   super
    # end

    def create
      build_resource(sign_up_params)

      resource.save
      yield resource if block_given?
      respond_to do |format|
        if resource.persisted?
          if resource.active_for_authentication?
            set_flash_message! :notice, :signed_up
            sign_up(resource_name, resource)
            format.js do
              redirect_to edit_user_registration_path,
                          notice: 'Ласкаво просимо! Ви успішно зареєструвалися.'
            end
          else
            set_flash_message! :notice,
                               "signed_up_but_#{resource.inactive_message}"
            expire_data_after_sign_in!
            respond_with resource,
                         location: after_inactive_sign_up_path_for(resource)
          end
        else
          clean_up_passwords resource
          set_minimum_password_length
          format.js { render :create }
        end
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
    # end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    def delete_avatar
      resource.avatar.try(:destroy) && resource.save if params[:drop_file]
    end

    # The path used after sign up.
    def after_sign_up_path_for(_resource)
      edit_user_registration_path
    end

    def after_update_path_for(_resource)
      edit_user_registration_path
    end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
