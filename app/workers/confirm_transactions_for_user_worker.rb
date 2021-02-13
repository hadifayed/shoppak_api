class ConfirmTransactionsForUserWorker
  include Sidekiq::Worker
  def perform(phone_number)
    user = User.find_by(phone_number: phone_number)
    user.sent_transactions.pending.each do |transaction|
      TransactionHandlerService.new(transaction: transaction).handle_confirmation
    end
  end
end
