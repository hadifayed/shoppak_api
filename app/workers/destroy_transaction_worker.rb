class DestroyTransactionWorker
  include Sidekiq::Worker
  def perform(transaction_id)
    TransactionHandlerService.new(transaction: Transaction.find(transaction_id)).handle_deleteion
  end
end
