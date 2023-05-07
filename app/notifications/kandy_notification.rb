# To deliver this notification:
#
# KandyNotification.with(post: @post).deliver_later(current_user)
# KandyNotification.with(post: @post).deliver(current_user)

class KandyNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: 'KandyMailer', format: :mailer_kandy
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"
  
  # Add required params
  #
  # param :account

  # Define helper methods to make rendering easier.
  #
  def message
    @kandy = Candy.find(params[:candy][:id])
    # @account = Account.find(params[:account][:id])
    @profile = Profile.find_by(profileable_id: @kandy.account_id, profileable_type: 'Account')
    "#{@profile.lastname.capitalize} #{@profile.firstname.capitalize} vient de publier un nouveau kandy"
  end
  
  def with(account)
    @account = account
    self
  end
  
  

  def url
    candy_path(Candy.find(params[:candy][:id]))
  end

  def mailer_kandy
    @kandy = Candy.find(params[:candy][:id])
    @profile = Profile.find_by(profileable_id: @kandy.account_id, profileable_type: 'Account')
    @recipient = Account.find(params[:account][:id])
    KandyMailer.notify(@recipient, @profile, @kandy).deliver_later
  end
end
