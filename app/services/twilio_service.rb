class TwilioService

  def initialize(phone_number:)
    @phone_number = phone_number
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def make_call
    @client.calls.create(url: "#{ENV['NGROK_URL']}/twilio/ask_for_confirmation",
                         to: @phone_number,
                         from: ENV['TWILIO_PHONE_NUMBER'])
  end
end
