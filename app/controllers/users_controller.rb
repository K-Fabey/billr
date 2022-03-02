class UsersController < ApplicationController

  def show
    @user = current_user
    authorize @user
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :email, :company_id, :role, :job_title, :phone_number)
  end
end
