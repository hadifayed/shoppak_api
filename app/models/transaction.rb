class Transaction < ApplicationRecord
  #-------------------------------- Associations -----------------------------------
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  #-------------------------------- Validations -----------------------------------
  validates :sender, :receiver, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :sender_is_not_the_receiver

  private
  def sender_is_not_the_receiver
    return if sender_id.nil? || receiver_id.nil?

    errors.add(:base, "You can't make a transaction for yourself") if sender_id == receiver_id
  end


end
