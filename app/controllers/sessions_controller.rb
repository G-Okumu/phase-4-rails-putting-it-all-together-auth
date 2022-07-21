class SessionsController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    before_action :require_login, only: :destroy

    def create
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            render json: user, status: :created
        else
        render json: { errors: ["Invalid username or password"] }, status: :unauthorized
        end
    end

    def destroy
        session.delete :user_id
        head :no_content
    end

    private
    def require_login
        user = User.find_by(id: session[:user_id])
    
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless user
    end
    
    def render_unprocessable_entity_response(exception)
        render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end
end
