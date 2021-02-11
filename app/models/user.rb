# frozen_string_literal: true

class User < ActiveRecord::Base
  #-------------------------------- Constants -----------------------------------
  INITIAL_CREDIT = 1000
  #-------------------------------- Plugins -----------------------------------
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User
  #-------------------------------- Call-Backs -----------------------------------
  before_validation :set_defaults, on: :create
  #-------------------------------- Validations -----------------------------------
  validates :name, :phone_number, presence: true
  validates :password, presence: true, on: :create
  validates :phone_number, format: /\A[+][0-9]+\Z/, uniqueness: { case_sensitive: true }

  private

  # here we override the method that checks for enabling record lock
  def locking_enabled?
    super && deducting_form_available_credit?
  end

  def deducting_form_available_credit?
    !self.id.nil? && self.available_credit_changed? && self.available_credit_was > self.available_credit
  end

  def set_defaults
    self.provider = "phone_number"
    self.uid = phone_number
    self.available_credit = INITIAL_CREDIT
    self.credit = INITIAL_CREDIT
  end
end
