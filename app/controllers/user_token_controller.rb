class UserTokenController < Knock::AuthTokenController
  private

  def auth_params
    params.require(:auth).permit(:username, :email, :password)
  end
end