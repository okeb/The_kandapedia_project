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
    ((@account != nil) && @question.account_id == @account.id && @question.is_published == false) or (@question.updated_at <= 2.days.ago && @question.is_published == true && (@account != nil) && @question.account_id == @account.id)
    # account.admin? coun|| !question.published? 
  end
end