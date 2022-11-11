class ProfilesController < ApplicationController
  #before_action :get_user_authenticate, only: %i[ :edit, :update ]
  before_action :charge_profile
  before_action -> { rodauth.require_authentication }, except: [ :show, :avatar_thumb, :charge_profile, :profile_params ]
  after_action :set_skills, only: %i[ :update ]

  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  # ActsAsTaggableOn.tags_table = 'skill_list'
  # ActsAsTaggableOn.taggings_table = 'skill_list'

  def pundit_user
    current_account
  end
  
  def show
    @questions = Question.all.where(account_id: @profile.account_id)
    #@profile = current_account.profile if @profile == nil
  end

  def edit
    authorize @profile
  end

  def update
    if @profile.update(profile_params)
      redirect_to @profile
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def avatar_thumb
    @profile.avatar.variant(resize_to_limit: [100, 100])
  end

  private

  def set_skills
    @profile[:skills] = @profile.skill_list.join ", "
    @profile.save!
  end

  def charge_profile
    @profile = Profile.find_by(id: params[:id])
  end

  def get_user_authenticate
      if rodauth.logged_in?
        @current_user = current_account
      end
  end

  def profile_params
    params.require(:profile).permit(:username, :firstname, :lastname, :job, :bio, :terms_of_service, :avatar, :skill_list,:skills, :color)
  end
end
