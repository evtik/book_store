class Users::RegistrationsController < Devise::RegistrationsController
  include AbstractController::Translation
  def update
    if resource.update_with_password(permitted)
      flash[:notice] = t('settings.change_password.changed_message')
      bypass_sign_in resource
    else
      clean_up_passwords(resource)
      flash[:alert] = resource.errors.full_messages.first
    end
    flash[:show_privacy] = true
    redirect_to after_update_path_for(resource)
  end

  def destroy
    super
    flash[:notice] = t('settings.remove_account.removed_message')
  end

  private

  def after_update_path_for(resource)
    user_settings_path(resource)
  end

  def permitted
    params.require(resource_name).permit(:emal, :current_password,
                                         :password, :password_confirmation)
  end
end
