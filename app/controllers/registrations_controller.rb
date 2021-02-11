class RegistrationsController < DeviseTokenAuth::RegistrationsController
  # overriding some methods cause we don't have an email field
  def provider
    'phone_number'
  end

  def build_resource
    @resource            = resource_class.new(sign_up_params)
    @resource.provider   = provider
  end

end
