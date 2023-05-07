# frozen_string_literal: true
class KandyMailer < ApplicationMailer
  default from: 'oliver@kandapedia.com'

  def notify(recipient, profile, kandy)
    @recipient = recipient
    @profile = profile
    @kandy = kandy
    mail(
      subject: "#{profile.lastname.capitalize} #{profile.firstname.capitalize} vient de publier un nouveau kandy🍬!!! 🤩✨",
      # to: 'from@kandapedia.com',
      to: recipient.email,
      from: 'from@kandapedia.com',
      track_opens: 'true',
      message_stream: 'outbound'
    )
  end
end

