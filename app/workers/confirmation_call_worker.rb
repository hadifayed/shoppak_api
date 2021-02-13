class ConfirmationCallWorker
  include Sidekiq::Worker
  def perform(phone_number)
    TwilioService.new(phone_number: phone_number).make_call
  end
end
