class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    before_action :require_login, only: :show

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find(session[:user_id])
        if session.include? :user_id
            render json: user
        else
            render json: {error: "unauthorized"}, status: :unauthhorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def require_login
        user = User.find_by(id: session[:user_id])
    
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless user
    end

    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
