class ProfilesController < ApplicationController
  before_action :charge_profile
  before_action -> { rodauth.require_authentication }, except: [ :show, :avatar_thumb, :charge_profile, :profile_params ]
  before_action :its_me, except: [ :show, :update, :avatar_thumb, :charge_profile, :profile_params ]

  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  
  def show
    @questions = Question.all.where(account_id: @profile.account_id)
  end

  def edit
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

  def charge_profile
    @profile = Profile.find_by(id: params[:id])
  end

  def its_me
    unless rodauth.session_value === @profile.account_id
      redirect_to @profile, notice: "vous n'êtes pas en mesure de modifier ce compte",status: 403
    end
  end

  def profile_params
    params.require(:profile).permit(:username, :firstname, :lastname, :job, :bio, :terms_of_service, :avatar, :skill_list, :color)
  end
end
