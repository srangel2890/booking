# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  private

  def encode_token(payload)
    JWT.encode(
      payload,
      Rails.application.secret_key_base,
      "HS256"
    )
  end

  def decoded_token
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    return unless token

    JWT.decode(
      token,
      Rails.application.secret_key_base,
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