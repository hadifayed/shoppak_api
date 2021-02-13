class CreditModifierService
  OPERATIONS = { add: 1, deduct: 2 }.freeze
  FIELDS = { credit: 1, available_credit: 2, credit_and_available_credit: 3 }.freeze

  def initialize(user:, operation:, fields:, amount:)
    @user = user
    @operation = operation
    @fields_to_be_changed = fields
    @amount = amount
  end

  def call
    update_with_lock_handled
    if @user.errors.full_messages.empty?
      { success: true , errors: [] }
    else
      { success: false , errors: @user.errors.full_messages }
    end
  end

  def update_with_lock_handled
    loop_again = true
    while loop_again
      begin
        loop_again = false
        @user.update(prepare_update_params)
      rescue ActiveRecord::StaleObjectError
        loop_again = true
        @user.reload
      end
    end
  end

  private

  def prepare_update_params
    fields_and_corresponding_values = prepare_params
    if @operation == OPERATIONS[:add]
      fields_and_corresponding_values.each { |field, value| fields_and_corresponding_values[field] = value + @amount }
    else
      fields_and_corresponding_values.each { |field, value| fields_and_corresponding_values[field] = value - @amount }
    end
    fields_and_corresponding_values
  end

  def prepare_params
    if @fields_to_be_changed == FIELDS[:credit]
      { credit: @user.credit }
    elsif @fields_to_be_changed == FIELDS[:available_credit]
      { available_credit: @user.available_credit }
    else
      { credit: @user.credit, available_credit: @user.available_credit }
    end
  end
end
