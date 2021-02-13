class UsersController < ApplicationController
  before_action :authenticate_user!

  def my_wallet
    render json: { credit: current_user.credit, available_credit: current_user.available_credit }, status: :ok
  end

end
