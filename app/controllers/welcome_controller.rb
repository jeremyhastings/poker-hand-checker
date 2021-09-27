class WelcomeController < ApplicationController
  def index
    @index_facade = Welcome::IndexFacade.new(params: params)

    respond_to do |format|
      format.html
      format.js { render(partial: 'index') }
    end
  end
end
