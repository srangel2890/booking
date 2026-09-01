module Api
  module V1
    class AuthController < ApplicationController
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          render json: {
            user: UserSerializer.new(user),
            token: user.get_token
          }, status: :ok
        else
          render json: {
            status: "error",
            message: "Must contain a valid email and password"
          }, status: :unauthorized
        end
      end
    end
  end
end