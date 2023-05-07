class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :set_notifications, if: :current_account

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
  
  def set_current_profile
    if rodauth.prefix === "/user"
      @current_profile =  Profile.find_by(profileable_id: current_account.id, profileable_type: "Account")
    else
      @current_profile =  Profile.find_by(profileable_id: current_account.id, profileable_type: "AdminAccount")
    end 
  end
  
  def set_notifications
    notifications = Notification.where(recipient: current_account).newest_first.limit(10)
    @read_notif = notifications.read
    @unread_notif = notifications.unread
  end

  helper_method :current_account

end
