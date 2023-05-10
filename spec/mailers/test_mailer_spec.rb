RSpec.describe TestMailer, type: :mailer do
  describe 'hello' do
    let(:mail) { TestMailer.hello }

    it 'renders the subject' do
      expect(mail.subject).to eq('Hello from Postmark')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['oliver@kandapedia.com'])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['oliver@kandapedia.com'])
    end
  end
end
