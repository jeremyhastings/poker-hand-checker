module Welcome
  class IndexFacade < ApplicationFacade
    def cards
      @cards ||= params[:poker_hand][:cards]
    end
  end
end
