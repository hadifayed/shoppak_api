class TransactionHandlerService
  attr_reader :transaction

  def initialize(transaction:)
    @transaction = transaction
  end

  def handle_creation
    response = nil
    result = ActiveRecord::Base.transaction do
      transaction.save
      response = CreditModifierService.new(user: transaction.sender,
                                           operation: CreditModifierService::OPERATIONS[:deduct],
                                           fields: CreditModifierService::FIELDS[:available_credit],
                                           amount: transaction.amount).call
      raise ActiveRecord::Rollback if !response[:success]
    end
    if response.try(:[], :success) && transaction.persisted?
      { success: true, errors: [], transaction: transaction }
    else
      errors = transaction.errors.full_messages
      errors += response[:errors] if response
      { success: false, errors: errors, transaction: transaction }
    end
  end

  def handle_confirmation
    transaction.update(confirmed_at: DateTime.now)
    CreditModifierService.new(user: transaction.sender,
                              operation: CreditModifierService::OPERATIONS[:deduct],
                              fields: CreditModifierService::FIELDS[:credit],
                              amount: transaction.amount).call
    CreditModifierService.new(user: transaction.receiver,
                              operation: CreditModifierService::OPERATIONS[:add],
                              fields: CreditModifierService::FIELDS[:credit_and_available_credit],
                              amount: transaction.amount).call
    { success: true, errors: [], transaction: transaction }
  end

  def handle_deleteion
    CreditModifierService.new(user: transaction.sender,
                              operation: CreditModifierService::OPERATIONS[:add],
                              fields: CreditModifierService::FIELDS[:available_credit],
                              amount: transaction.amount).call
    transaction.destroy
    { success: true, errors: [], transaction: transaction }
  end

end
