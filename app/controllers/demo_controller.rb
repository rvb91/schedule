class DemoController < ApplicationController

  def index
    redirect_to after_sign_in_path_for(current_user)
  end
end
