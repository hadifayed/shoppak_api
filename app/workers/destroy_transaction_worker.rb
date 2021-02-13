class DestroyTransactionWorker
  include Sidekiq::Worker
  def perform(transaction_id)
    notification_class_name.camelize.constantize.send_notification(notification_params.deep_symbolize_keys!)
  end
end
