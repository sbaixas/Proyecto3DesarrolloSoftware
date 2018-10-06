# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :require_no_authentication, only: :cancel
  skip_before_action :verify_authenticity_token
  # GET /resource/sign_in
  def new
    #   UserMailer.with(user: User.first).welcome_email.deliver_now

    super
  end

  # POST /resource/sign_in
  def create
    respond_to do |format|
      format.html {super}
      format.json {
        user_email=params[:email]
        password=params[:password]
        user=User.find_by_email(user_email)
        if(!user)
          render :json => {status:401},status: :unauthorized
        elsif user.valid_password?(password)
          render :json =>{Authorization:user.auth_token}, status: :ok
        else
          render :json =>{status:401}, status: :unauthorized
        end
      }

    end

  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password",:status=>401}, :status=>401
  end
  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
