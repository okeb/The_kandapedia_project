class QuestionPolicy
  attr_reader :account, :question

  def initialize(account, question)
    @account = account
    @question = question
  end

  def update?
    # account.admin? || !question.published?
  end
end