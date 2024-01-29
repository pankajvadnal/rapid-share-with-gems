# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      set_flash_message :notice, :signed_up
      sign_up(resource_name, resource)
      # redirect_to after_update_path_for(resource)
      respond_with resource, location: after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :new, status: 422
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    if resource.update(account_update_params)
      set_flash_message :notice, :updated
      bypass_sign_in resource, scope: resource_name
      redirect_to after_update_path_for(resource)
      # render json: { message: 'User updated successfully' }, status: :ok
    else
      clean_up_passwords resource
      set_minimum_password_length
      render :edit, status: 422
      # render 'edit'
      # render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /resource
#   def destroy
#     super
#   end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
#   def cancel
#     super
#   end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :email, :password])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    # super(resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :name, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :name, :email, :password])
  end

end
