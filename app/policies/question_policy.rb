class QuestionPolicy
  attr_reader :account, :question

  def initialize(account, question)
    @account = account
    @question = question
  end

  def new?
    @account!= nil
  end

  def edit?
   (@account != nil) and @question.account_id == @account.id
    # account.admin? || !question.published?
  end
end