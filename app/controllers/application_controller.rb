class ApplicationController < ActionController::API
  private

  def decoded_token
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    return unless token

    JWT.decode(
      token,
      Rails.application.credentials.secret_jwt_key,
      true,
      algorithm: "HS256"
    ).first
  rescue JWT::DecodeError
    nil
  end

  def current_user
    return @current_user if defined?(@current_user)

    payload = decoded_token
    @current_user = payload && User.find_by(id: payload["user_id"])
  end

  def authenticate_user!
    return if current_user

    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end