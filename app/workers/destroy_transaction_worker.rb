class DestroyTransactionWorker
  include Sidekiq::Worker
  def perform(transaction_id)
    transaction = Transaction.find(transaction_id)
    return if transaction.confirmed_at.present?
    TransactionHandlerService.new(transaction: transaction).handle_deleteion
  end
end
