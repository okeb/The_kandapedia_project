class TestMailer < ApplicationMailer
  default from: 'oliver@kandapedia.com'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'oliver@kandapedia.com',
      from: 'oliver@kandapedia.com',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound')
  end
end