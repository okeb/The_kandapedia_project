# frozen_string_literal: true
class ProfilesController < ApplicationController
  before_action :charge_profile
  before_action -> { rodauth.require_authentication },
                only: %i[edit update follow_profile unfollow_profile blocking_profile unblocking_profile accept_following
                         cancel_following]
  before_action -> { rodauth.require_authentication },
                except: %i[show avatar_thumb charge_profile profile_params]
  after_action :set_skills, only: %i[update]

  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  # ActsAsTaggableOn.tags_table = 'skill_list'
  # ActsAsTaggableOn.taggings_table = 'skill_list'

  def pundit_user
    current_account
  end

  def follow_profile
    current_account.send_follow_request_to(@profile.profileable)
    current_account.activity_rate += 0.01
    current_account.save!
    redirect_to profiles_path(@profile)
  end

  def unfollow_profile
    make_it_an_unfriend_request

    current_account.activity_rate -= 0.01
    current_account.save!
    current_account.unfollow(@profile.profileable)
    redirect_to profiles_path(@profile)
  end

  def blocking_profile
    make_it_an_unfriend_request

    current_account.activity_rate -= 0.002
    current_account.save!
    current_account.block(@profile.profileable)
    redirect_to profiles_path(@profile)
  end

  def unblocking_profile
    make_it_an_unfriend_request

    current_account.activity_rate += 0.002
    current_account.save!
    current_account.unblock(@profile.profileable)
    redirect_to profiles_path(@profile)
  end

  def decline_following
    current_account.activity_rate += 0.002
    current_account.save!
    current_account.decline_follow_request_of(@profile.profileable)
    redirect_to root_path
  end

  def accept_following
    current_account.activity_rate += 0.01
    current_account.save!
    current_account.accept_follow_request_of(@profile.profileable)
    make_it_a_friend_request

    redirect_to root_path
  end

  def cancel_following
    current_account.activity_rate -= 0.02
    current_account.save!
    current_account.remove_follow_request_for(@profile.profileable)
    redirect_to root_path
  end

  def show
    # profile_id = @profile.id
    # @questions = Question.joins(profile: { account: :profile }).where('profiles.id = ?', profile_id)
    @questions = Question.all.where(account_id: @profile.profileable_id)
    @kandies = Candy.all.where(account_id: @profile.profileable_id)
    @profile.profileable.activity_rate -= 0.0001
    @profile.profileable.save!
    @profile = current_account.profile if @profile === nil
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
    current_account.send_follow_request_to(@profile.profileable)
    @profile.profileable.accept_follow_request_of(current_account)
    current_account.activity_rate += 0.1
    current_account.save!
    @profile.profileable.activity_rate += 0.0005
    @profile.profileable.save!
  end

  def make_it_an_unfriend_request
    return unless @profile.profileable.mutual_following_with?(current_account)

    @profile.profileable.unfollow(current_account)
    current_account.activity_rate += 0.1
    current_account.save!
    @profile.profileable.activity_rate -= 0.001
    @profile.profileable.save!
  end

  def set_skills
    @profile[:skills] = @profile.skill_list.join ', '
    @profile.save!
  end

  def charge_profile
    if rodauth.prefix === "/user"
      @profile = Profile.friendly.where(profileable_id: params[:id], profileable_type: "Account").first
    else
      @profile = Profile.friendly.where(profileable_id: params[:id], profileable_type: "AdminAccount").first
    end

    return unless @profile.nil? && !params[:id].nil?

    @profile = Profile.friendly.find(params[:id])

  end

  def user_authenticate
    return unless rodauth.logged_in?

    @current_user = current_account
  end

  def profile_params
    params.require(:profile).permit(:username, :firstname, :lastname, :job, :bio, :terms_of_service, :avatar,
                                    :skill_list, :skills, :color)
  end
end
