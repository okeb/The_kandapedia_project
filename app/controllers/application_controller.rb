class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:notice] = "Désolé, vous n'êtes pas autorisé à effectuer cette action."
    redirect_to(request.referrer || root_path)
  end

  def authenticate
    rodauth.require_account # redirect to login page if not authenticated
  end

  def current_account
    rodauth.rails_account
  end

  helper_method :current_account

end
