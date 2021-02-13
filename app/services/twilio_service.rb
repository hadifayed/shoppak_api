class TwilioService

  def initialize(phone_number:)
    @phone_number = phone_number
    account_sid = 'ACb2af0dadbee4c5c41aa04c97ca08309c'
    auth_token = '496fd1fc4536116eb584aa8b2c9ee192'
    @client = Twilio::REST::Client.new(account_sid, auth_token)
  end

  def make_call
    @client.calls.create(url: "#{ENV['NGROK_URL']}/twilio/ask_for_confirmation",
                         to: @phone_number,
                         from: '+12017338319')
  end
end
