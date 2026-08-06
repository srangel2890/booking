
module Api
  module V1
    class AuthController < ApplicationController
      def login
        user = User.find_by(email: params[:email])
        if !!user && user.authenticate(params[:password])
          render json: UserSerializer.new(user)
        else
          render json: {status: "error", message: "Must contain a valid email and password"}
        end
      end
    end
  end
end
