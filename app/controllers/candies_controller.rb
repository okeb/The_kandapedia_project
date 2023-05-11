class CandiesController < ApplicationController

  before_action -> { rodauth.require_authentication }, except: %i[index show]
  before_action :user_authenticate
  before_action -> { set_candy }, only: %i[toggle_to_bookmark show]

  after_action :increment_candy_counter, only: %i[create]
  after_action :decrement_candy_counter, only: %i[destroy]
  include CurrentProfile
  include AccountRelations

  # ActsAsTaggableOn.remove_unused_tags = true
  # ActsAsTaggableOn.force_lowercase = true

  def index
    @candies = Candy.includes(account: [:profile]).desc
    @relations = if rodauth.logged_in?
                   @relationships = ours_relations current_account, 5
                   if @relationships.count === 0
                     Account.where("accounts.id != #{current_account.id}").limit(5).order(activity_rate: :desc, id: :desc)
                   else
                     @relationships
                   end
                 else
                   Account.where("accounts.id != #{current_account.id}").limit(21).order(activity_rate: :desc, id: :desc)
                 end
  end

  def show
    # @candy = Candy.find_by(id: params[:id])
    @account = @candy.account
    @Profile = @account.profile
    if rodauth.logged_in?
      unless current_account.voted_up_on? @candy, vote_scope: :view
        if current_account.voted_up_on? @candy, vote_scope: :author
          increment_candy_view @candy, 0, 'add'
        else
          increment_candy_view @candy
        end
        manage_relation current_account, @candy.account, 4, :expo
        @candy.upvote_from current_account, vote_scope: :view
      end
    else
      increment_candy_view @candy, 0.0000001, 'add'
    end
  end

  def new
    @candy = Candy.new(scope: 'public_scope')
  end

  def create
    @candy = current_account.candies.build(candy_params)
    if !@candy.image.nil? && @candy.image.presence?
      if @current_profile.is_verified?
        increment_candy_note(@candy, 1.04)
      else
        increment_candy_note(@candy, 1.02)
      end
    end

    respond_to do |format|
      if @candy.save
        format.html { redirect_to @candy }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @candy.update(candy_params)
        format.html { redirect_to @candy }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy; end

  def see_the_author
    @candy = Candy.find_by(uuid: params[:candy_id])
    unless current_account.voted_up_on? @candy, vote_scope: :author
      if current_account.voted_up_on? @candy, vote_scope: :view
        decrement_candy_note(@candy, 1.11)
        increment_candy_note(@candy, 1.12)
        @candy.save!
      else
        increment_candy_note(@candy, 1.24)
        @candy.save!
      end
      manage_relation current_account, @candy.account, 1.008, :expo
      @candy.upvote_from current_account, vote_scope: :author
    end

    @profile = Profile.find_by(profileable_id: @candy.account_id, profileable_type: 'Account')
    redirect_to @profile
  end

  def toggle_to_bookmark
    @candy = Candy.find_by(uuid: params[:candy_id])
    if current_account.voted_up_on? @candy, vote_scope: :bookmark
      @candy.unvote_by current_account, vote_scope: :bookmark
      decrement_candy_note @candy, 0.01, 'add'
      @candy.save!
      manage_relation current_account, @candy.account, 1.002, :div
    else
      @candy.upvote_from current_account, vote_scope: :bookmark
      increment_candy_note @candy, 0.01, 'add'
      @candy.save!
      manage_relation current_account, @candy.account, 1.002, :expo
    end
    respond_to do |format|
      format.html { redirect_to candies_path }
    end
  end

  def toggle_to_like
    @candy = Candy.find_by(uuid: params[:candy_id])
    if current_account.voted_up_on? @candy, vote_scope: :like
      @candy.unvote_by current_account, vote_scope: :like
      decrement_candy_like @candy
      manage_relation current_account, @candy.account, 1.07, :div
    else
      @candy.upvote_from current_account, vote_scope: :like
      increment_candy_like @candy
      manage_relation current_account, @candy.account, 1.07, :expo
    end
    respond_to do |format|
      format.html { redirect_to candies_path }
    end
  end

  def toggle_to_boost
    @candy = Candy.find_by(uuid: params[:candy_id])
    if current_account.voted_up_on? @candy, vote_scope: :boost
      @candy.unvote_by current_account, vote_scope: :boost
      decrement_candy_boost @candy
      manage_relation current_account, @candy.account, 1.05, :div
    else
      @candy.upvote_from current_account, vote_scope: :boost
      increment_candy_boost @candy
      manage_relation current_account, @candy.account, 1.05, :expo
    end
    respond_to do |format|
      format.html { redirect_to candies_path }
    end
  end


  private

  def increment_candy_counter
    current_account.candies_count += 1
    current_account.activity_rate += 0.05
    current_account.save!
  end

  def decrement_candy_counter
    current_account.candies_count -= 1
    current_account.activity_rate -= 0.05
    current_account.save!
  end

  def increment_candy_view(candy, value_add = 0, option = '')
    if option != ''
      increment_candy_note(candy, value_add, option)
    else
      increment_candy_note(candy, 1.22)
    end
    candy.view += 1
    candy.save!
    current_account.activity_rate += 0.003
    current_account.save!
  end

  def increment_candy_like candy
    increment_candy_note(candy, 1.3)
    candy.like += 1
    candy.save!
    current_account.activity_rate += 0.005
    current_account.save!
  end

  def decrement_candy_like candy
    decrement_candy_note(candy, 1.3)
    candy.like -= 1
    candy.save!
    current_account.activity_rate -= 0.005
    current_account.save!
  end

  def increment_candy_boost candy
    increment_candy_note(candy, 1.2)
    candy.boost += 1
    candy.save!
    current_account.activity_rate += 0.0025
    current_account.save!
  end

  def decrement_candy_boost candy
    decrement_candy_note(candy, 1.2)
    candy.boost -= 1
    candy.save!
    current_account.activity_rate -= 0.0025
    current_account.save!
  end

  def increment_candy_note(candy, value, option = '')
    if option === 'add'
      candy.note += value
    else
      candy.note *= value
    end
  end

  def decrement_candy_note(candy, value, option = '')
    if option === ('add' || 'remove' || 'less')
      candy.note -= value
    else
      candy.note /= value
    end
  end

  def set_candy
    @candy = Candy.find_by(uuid: params[:id])
  end


  def user_authenticate
    return unless rodauth.logged_in?

    @current_user = current_account

  end

  def candy_params
    params.require(:candy).permit(:body, :scope, :view, :position, :parent_id, :account_id, :image)
  end
end
