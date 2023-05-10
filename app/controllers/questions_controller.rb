class QuestionsController < ApplicationController
  before_action -> { rodauth.require_authentication }, except: %i[index show]
  before_action :user_authenticate
  before_action :set_question_by_slug, only: %i[update show edit destroy]
  before_action :find_question_for_vote,
                only: %i[toggle_to_bookmark add_to_readlist remove_to_readlist add_awesome add_perfect add_nice add_wrong add_bad
                get_global_appreciation_value get_appreciation]
  after_action :set_tags, only: %i[create]
  after_action :give_new_slug, only: %i[update]
  after_action :increment_question_counter, only: %i[create]
  after_action :decrement_question_counter, only: %i[destroy]

  ActsAsTaggableOn.remove_unused_tags = true
  ActsAsTaggableOn.force_lowercase = true
  # ActsAsTaggableOn.tags_table = 'tag_list'
  # ActsAsTaggableOn.taggings_table = 'tag_list'

  impressionist actions: [:show],
                unique: %i[action_name session_hash user_id impressionable_type impressionable_id ip_address]
  impressionist actions: [:index], unique: %i[impressionable_type impressionable_id session_hash ip_address]

  def pundit_user
    current_account
  end

  # GET /questions or /questions.json
  def index
    @questions = Question.includes(account: :profile)
    # @questions = Question.includes(account: :profile).where(is_private: false)
  end

  # GET /questions/1 or /questions/1.json
  def show
    @profile = Profile.find_by(profileable_id: @question.account_id)
    impressionist(@question, "visionnage de la question : #{@question.title}")
  end

  # add or remove the question to the bookmark of the user
  def toggle_to_bookmark
    if current_account.voted_up_on? @question, vote_scope: :bookmark
      @question.unvote_by current_account, vote_scope: :bookmark
    else
      @question.upvote_from current_account, vote_scope: :bookmark
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end
  end

  # add appreciation to the question
  def add_awesome
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 3)
      remove_appreciation
      decrement_likes_counter(@question)
    else
      if current_account.voted_up_on? @question, vote_scope: :appreciation
        decrement_likes_counter(@question)
      end
      @question.upvote_by current_account, vote_scope: :appreciation, vote_weight: 3
      increment_likes_counter(@question)
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end
  end

  def add_perfect
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 2)
      remove_appreciation
      decrement_likes_counter(@question)
    else
      if current_account.voted_up_on? @question, vote_scope: :appreciation
        decrement_likes_counter(@question)
      end
      @question.upvote_by current_account, vote_scope: :appreciation, vote_weight: 2
      increment_likes_counter(@question)
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end
  end

  def add_nice
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 1)
      remove_appreciation
      decrement_likes_counter(@question)
    else
      if current_account.voted_up_on? @question, vote_scope: :appreciation
        decrement_likes_counter(@question)
      end
      @question.upvote_by current_account, vote_scope: :appreciation, vote_weight: 1
      increment_likes_counter(@question)
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end

  end

  def add_wrong
    if current_account.voted_up_on? @question, vote_scope: :appreciation
      decrement_likes_counter(@question)
    end
    if (current_account.voted_down_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 1)
      remove_appreciation
    else
      @question.downvote_by current_account, vote_scope: :appreciation, vote_weight: 1
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end
  end

  def add_bad
    if current_account.voted_up_on? @question, vote_scope: :appreciation
      decrement_likes_counter(@question)
    end
    if (current_account.voted_down_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 2)
      remove_appreciation
    else
      @question.downvote_by current_account, vote_scope: :appreciation, vote_weight: 2
    end
    respond_to do |format|
      format.html { redirect_to @question }
    end
  end

  # to verify if user has give an appreciation to the question
  def has_appreciate
    get_appreciation? nil
  end

  # get the global appreciation value of @question
  def get_global_appreciation_value
    upvote_global_value = (@question.get_upvotes(vote_scope: :appr_awesome).sum(:vote_weight)).to_i + (@question.get_upvotes(vote_scope: :appr_perfect).sum(:vote_weight)).to_i +  (@question.get_upvotes(vote_scope: :appr_nice).sum(:vote_weight)).to_i

    downvote_global_value = (@question.get_downvotes(vote_scope: :appr_wrong).sum(:vote_weight)).to_i - (@question.get_downvotes(vote_scope: :appr_bad).sum(:vote_weight)).to_i

    upvote_global_value - downvote_global_value
  end

  # add the question to a readlater list of the user
  def add_to_readlist
    if current_account.voted_for? @question, vote_scope: :readlist
      if current_account.voted_down_on? @question, vote_scope: :readlist
        @question.upvote_from current_account, vote_scope: :readlist
      else
        @question.downvote_from current_account, vote_scope: :readlist
      end
    else
      @question.downvote_from current_account, vote_scope: :readlist
    end
    respond_to do |format|
      format.html { redirect_to @question }
      # format.turbo_stream
    end
  end

  # remove the question to a readlater list of the user
  def remove_to_readlist
    if current_account.voted_for? @question, vote_scope: :readlist
      @question.unvote_by current_account, vote_scope: :readlist
    end
    respond_to do |format|
      format.html { redirect_to @question }
      # format.turbo_stream
    end
  end


  # GET /questions/new
  def new
    @question = Question.new
  end

  # POST /questions or /questions.json
  def create
    @question = current_account.questions.build(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @question
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def update_tags
    @question =Question.find_by(slug: params[:question_id])
    respond_to do |format|
      if @question.update(question_params_without_tags)
        @question[:tags] = @question.tag_list.join(', ')
        @question.save!
        format.html { redirect_to @question }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
    end
  end

  private

  require 'json'

  def add_bookmark_list
    current_account.questions_count += 1
    current_account.save!
  end

  def remove_bookmark_list(question, profile)
    bookmark_list = JSON.parse(profile.bookmark_list)
    id_question = question.id
    if bookmark_list.include? id_question
      profile.bookmark_list
      current_account.save!
    end
  end

  def increment_question_counter
    current_account.questions_count += 1
    current_account.activity_rate += 0.1
    current_account.save!
  end

  def decrement_question_counter
    current_account.questions_count -= 1
    current_account.activity_rate -= 0.1
    current_account.save!
  end

  def increment_likes_counter(item)
    current_account.activity_rate += 0.007
    current_account.save!
    item.likes_count += 1
    item.save!
  end

  def decrement_likes_counter(item)
    current_account.activity_rate -= 0.007
    current_account.save!
    item.likes_count -= 1
    item.save!
  end

  def set_tags
    @question[:tags] = @question.tag_list.join(', ')
    @question.save!
  end

  # remove all appreciation by the current account to the question @question
  def remove_appreciation
    if current_account.voted_for? @question, vote_scope: :appreciation
      @question.unvote_by current_account, vote_scope: :appreciation
    end
  end

  # get the word to precise the appreciation [ awesome, perfect, nice, wrong, bad ]
  def get_appreciation
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 3)
      'awesome'
    end
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 2)
      'perfect'
    end
    if (current_account.voted_up_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 1)
      'nice'
    end
    if (current_account.voted_down_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 1)
      'wrong'
    end
    if (current_account.voted_down_on? @question, vote_scope: :appreciation) && (current_account.vote_weight_on(@question, vote_scope: :appreciation) === 2)
      'bad'
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question_by_slug
    @question = Question.find_by(slug: params[:id])
    if (@question == nil)
      redirect_to questions_path
    else
      @question
    end
  end

    # get the right question to vote
  def find_question_for_vote
    unless (Question.find_by(slug: params[:question_id]))
      redirect_to questions_path
    end
    @question = Question.find_by(slug: params[:question_id])
  end

  def give_new_slug
    @question.slug
  end

  def user_authenticate
    if rodauth.logged_in?
      @current_user = current_account
    end
  end


  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question).permit(:title, :body, :is_private, :position, :parent_id)
  end
  def question_params_without_tags
    params.require(:question).permit(:title, :body, :is_private, :position, :parent_id, :tag_list, :likes_count, :tags)
  end
end
