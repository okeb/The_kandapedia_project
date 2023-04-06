class ProfilesController < ApplicationController
  #before_action :get_user_authenticate, only: %i[ :edit, :update ]
  before_action :charge_profile
  before_action -> { rodauth.require_authentication }, :set_user
  before_action -> { rodauth.require_authentication }, except: [ :show, :avatar_thumb, :charge_profile, :profile_params ]
  after_action :set_skills, only: %i[ :update ]

  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  # ActsAsTaggableOn.tags_table = 'skill_list'
  # ActsAsTaggableOn.taggings_table = 'skill_list'

  def pundit_user
    current_account
  end

  def follow_profile
    current_account.send_follow_request_to(@user)
    redirect_to profiles_path(@profile)
  end

  def unfollow_profile
    make_it_an_unfriend_request

    current_account.unfollow(@user)
    redirect_to profiles_path(@profile)
  end

  def blocking_profile
    make_it_an_unfriend_request

    current_account.block(@user)
    redirect_to profiles_path(@profile)
  end

  def unblocking_profile
    make_it_an_unfriend_request

    current_account.unblock(@user)
    redirect_to profiles_path(@profile)
  end

  def decline_following
    current_account.decline_follow_request_of(@user)
    redirect_to root_path
  end
  
  def accept_following
    current_account.accept_follow_request_of(@user)
    make_it_a_friend_request

    redirect_to root_path
  end

  def cancel_following
    current_account.remove_follow_request_for(@user)
    redirect_to root_path
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

  def make_it_a_friend_request
    current_account.send_follow_request_to(@user)
    @user.accept_follow_request_of(current_account)
  end

  def make_it_an_unfriend_request
    @user.unfollow(current_account) if @user.mutual_following_with?(current_account)
  end

  def set_user
    @user = Account.find_by(id: @profile.account_id)
  end

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
