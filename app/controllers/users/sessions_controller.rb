class Users
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params, only: :create
  end
end
