class ApplicationController < ActionController::API
  include ActionController::Cookies
  # Filters are inherited, so if you set a filter on ApplicationController, it will be run on every controller in your application.

  rescue_from ActiveRecord::RecordInvalid, with: :render_invalid
  before_action :require_login

  private

  def require_login
    @logged_user = User.find_by(id: session[:user_id])

    render json: { errors: ["Not authorized"] }, status: :unauthorized unless @logged_user
  end

    def render_invalid(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity

    end
end
