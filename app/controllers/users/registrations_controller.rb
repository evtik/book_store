class Users::RegistrationsController < Devise::RegistrationsController
  include AbstractController::Translation
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
    # super
  # end

  # PUT /resource
  def update
    if resource.update_with_password(permitted)
      flash[:notice] = t('user_settings.change_password.changed_message')
      # sign_in resource_name, resource, bypass: true
      bypass_sign_in resource
    else
      clean_up_passwords(resource)
      flash[:alert] = resource.errors.full_messages.first
    end
    flash[:show_privacy] = true
    redirect_to after_update_path_for(resource)
  end

  # DELETE /resource
  def destroy
    super
    flash[:notice] = t('user_settings.remove_account.removed_message')
  end

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

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def after_update_path_for(resource)
    user_settings_path(resource)
  end

  def permitted
    params.require(resource_name).permit(:emal, :current_password,
                                         :password, :password_confirmation)
  end
end
