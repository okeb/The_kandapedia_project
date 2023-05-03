class CandiesController < ApplicationController

  before_action -> { rodauth.require_authentication }, except: %i[index show]
  before_action :user_authenticate

  after_action :increment_candy_counter, only: %i[create]
  after_action :decrement_candy_counter, only: %i[destroy]
  # ActsAsTaggableOn.remove_unused_tags = true
  # ActsAsTaggableOn.force_lowercase = true

  def index
    @candies = Candy.includes(account: [:profile])
  end

  def show
    @candy = Candy.find_by(id: params[:id])
    @account = @candy.account
    @Profile = @account.profile
  end

  def new
    @candy = Candy.new(scope: 'public_scope')
  end

  def create
    @candy = current_account.candies.build(candy_params)
    
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

  private
  def increment_candy_counter
    current_account.candies_count += 1
    current_account.save!
  end

  def decrement_candy_counter
    current_account.candies_count -= 1
    current_account.save!
  end

  def user_authenticate
    return unless rodauth.logged_in?

    @current_user = current_account

  end

  def candy_params
    params.require(:candy).permit(:body, :scope, :view, :position, :account_id)
  end
end
