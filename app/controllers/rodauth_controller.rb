class RodauthController < ApplicationController
  # used by Rodauth for rendering views, CSRF protection, and running any
  # registered action callbacks and rescue_from handlers

  before_action :redirect_if_logged_in


  private

  def redirect_if_logged_in
    if rodauth.logged_in? && request.path == rodauth.login_path
      flash[:notice] = "Vous êtes déjà connecté"
      redirect_to root_path # Remplacez dashboard_path par l'URL de la page de destination
    end
  end
end
