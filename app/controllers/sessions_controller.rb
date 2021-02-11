class SessionsController < DeviseTokenAuth::SessionsController
  # override the default provider
  def provider
    'phone_number'
  end
end
