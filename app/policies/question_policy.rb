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
    (((@account != nil) and @question.account_id == @account.id) and ((@question.updated_at <= 1.days.ago) and @question.is_published == true))
    # account.admin? || !question.published?
  end
end