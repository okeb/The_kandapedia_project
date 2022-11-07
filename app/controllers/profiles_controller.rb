class ProfilesController < ApplicationController
  before_action -> { rodauth.require_authentication }, except: [ :index, :show ]
  before_action :its_me, except: [ :index, :show ]
  before_action :charge_profile

  def show
    # 44 != "la phrase"
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

  # def avatar_thumb
  #   @profile.avatar.variant(resize_to_limit: [100, 100])
  # end

  private

  def charge_profile
    @profile = Profile.find_by(account_id: params[:id])
  end

  def its_me
    unless rodauth.session_value === params[:id].to_i
      puts "isn't you"
      redirect_back fallback_location: '/', allow_other_host: false, notice: "vous n'êtes pas en mesure de modifier ce compte",status: 403

    end
  end

  def profile_params
    params.require(:profile).permit(:firstname, :lastname, :job, :bio, :avatar, :skill_list)
  end
end
