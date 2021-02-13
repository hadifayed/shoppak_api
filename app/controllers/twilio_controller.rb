class TwilioController < ActionController::API
  def ask_for_confirmation
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.gather(numDigits: 3, action: "#{ENV['NGROK_URL']}/twilio/submit_confirmation") do |g|
        g.say(message: "Please press #{Transaction::CONFIRMATION_CODE_DATA[:text]} to confirm pending transactions")
      end
      r.redirect("#{ENV['NGROK_URL']}/twilio/ask_for_confirmation")
    end.to_s
    render xml: response, status: :ok
  end

  def submit_confirmation
    confirmation_code = params['Digits']
    if confirmation_code.to_i == Transaction::CONFIRMATION_CODE_DATA[:code]
      msg = "Thank you your transactions is being processed now"
      ConfirmTransactionsForUserWorker.perform_async(params['To'])
    else
      msg = "Sorry wrong confirmation code"
    end
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(message: msg)
    end.to_s
    render xml: response, status: :ok
  end

end
