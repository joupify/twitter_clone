class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern


  before_action :authenticate_user!
  before_action :set_current_user

  private

  def set_current_user
    ::CurrentAttributes.user = current_user
  end


end
