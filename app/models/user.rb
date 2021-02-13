# frozen_string_literal: true

class User < ActiveRecord::Base
  #-------------------------------- Constants -----------------------------------
  INITIAL_CREDIT = 1000
  #-------------------------------- Plugins -----------------------------------
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User
  #-------------------------------- Call-Backs -----------------------------------
  before_validation :set_defaults, on: :create
  #-------------------------------- Associations -----------------------------------
  has_many :received_transactions, class_name: 'Transaction', foreign_key: :receiver_id
  has_many :sent_transactions, class_name: 'Transaction', foreign_key: :sender_id
  #-------------------------------- Validations -----------------------------------
  validates :name, :phone_number, presence: true
  validates :password, presence: true, on: :create
  validates :phone_number, format: /\A[+][0-9]+\Z/, uniqueness: { case_sensitive: true }
  validates :available_credit, numericality: { greater_than_or_equal_to: 0 }

  private

  # overriding locking_enabled method to prevent incrementing the lock version for unnecessary changes
  def locking_enabled?
    super && credit_fields_changed?
  end

  def credit_fields_changed?
    self.persisted? && (self.credit_changed? || self.available_credit_changed?)
  end

  def set_defaults
    self.provider = "phone_number"
    self.uid = phone_number
    self.available_credit = INITIAL_CREDIT
    self.credit = INITIAL_CREDIT
  end
end
