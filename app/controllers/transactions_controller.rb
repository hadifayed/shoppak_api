class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: { received_transactions: current_user.received_transactions,
                   sent_transactions: current_user.sent_transactions}, status: :ok
  end

  def create
    transaction = Transaction.new(transaction_params.merge(sender_id: current_user.id))
    response = TransactionHandlerService.new(transaction: transaction).handle_creation
    if response[:success]
      DestroyTransactionWorker.perform_in(5.minutes, response[:transaction].id)
      render json: response[:transaction], status: :created
    else
      render json: response[:errors], status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:receiver_id, :amount)
  end
end
