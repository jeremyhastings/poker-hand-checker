class WelcomeController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js { render(partial: 'index') }
    end
  end
end
