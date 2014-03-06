class AuthController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  respond_to :json

  def auth
    login, password = params[:login], params[:password]

    user = User.authenticate login, password
    if user
      render json: {success: true, login: user.email}
    else
      render json: {success: false, error: 'Invalid login data'}
    end
  end
end
