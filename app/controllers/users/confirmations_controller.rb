# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController

  skip_before_action :verify_authenticity_token

  def activate

    email = params[:email]
    user = User.find_by_email(email)
    rand_password = User.random_string(10)
    user.update(password:rand_password)
    UserMailer .with(user:user,password:rand_password).activation_email.deliver_now
    render json:{status:200}, status: :ok
  end
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
