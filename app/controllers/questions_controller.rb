class QuestionsController < ApplicationController
  before_action -> { rodauth.require_authentication }, except: %i[ index ]
  before_action :set_question, only: %i[ show update destroy ]
  before_action :find_question_by_slug, only: %i[ show update ]
  after_action :give_new_slug, only: %i[ update ]

  # GET /questions or /questions.json
  def index
    @questions = Question.includes(:account)
    @profiles = Profile.all
  end

  # GET /questions/1 or /questions/1.json
  def show
    @profile = Profile.find_by(account_id: @question.account_id)
  end

  # add or remove the question to the bookmark of the user
  def toggle_to_bookmark
    if current_account.voted_up_on? @question, vote_scope: :bookmark
      @question.unvote_by voter: current_account, vote_scope: :bookmark
    else
      @question.upvote_from current_account, vote_scope: :bookmark
    end
    respond_to do |format|
        format.turbo_stream
    end
  end

  # add the question to a readlater list of the user
  def add_to_readlist
    if current_account.voted_for? @question, vote_scope: :readlist
      if current_account.voted_down_on? @question, vote_scope: :readlist
        @question.unvote_by current_account, vote_scope: :readlist
      else
        @question.downvote_from current_account, vote_scope: :readlist
      end
    else
      @question.downvote_from current_account, vote_scope: :readlist
    end
    respond_to do |format|
        format.turbo_stream
    end
  end

  # remove the question to a readlater list of the user
  def remove_to_readlist
    if current_account.voted_for? @question, vote_scope: :readlist
      @question.unvote_by current_account, vote_scope: :readlist
    end
    respond_to do |format|
        format.turbo_stream
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

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url, notice: "Question was successfully destroyed." }
    end
  end

  private

    def find_question_by_slug
      @question = Question.find_by(slug: params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      unless (Question.find_by(slug: params[:id]))
        redirect_to questions_path
      end
    end

    def give_new_slug
      @question.slug
    end
    

    # Only allow a list of trusted parameters through.
    def question_params
      params.require(:question).permit(:title, :body, :position, :parent_id)
    end
    
    def create_question_params
      params.require(:question).permit(:title, :position, :parent_id)
    end
end
