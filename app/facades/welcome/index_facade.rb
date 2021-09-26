require_relative '../../../lib/poker_parser/poker_parser'

module Welcome
  class IndexFacade < ApplicationFacade
    include PokerParser

    def process_hand
      return 'Invalid hand' unless validates_uniqueness_and_count

      separate_face_and_suit
      create_poker_cards
      poker_hand.any?(&:nil?) ? 'Invalid hand' : hand_score(poker_hand)
    end

    private

    def validates_uniqueness_and_count
      raw_data.count == 5 && raw_data.uniq.count == 5
    end

    def separate_face_and_suit
      raw_data.uniq.each do |data|
        processed_data << (data.length == 2 ? [data.first, data.last] : [data.first(2), data.last])
      end
    end

    def raw_data
      @raw_data ||= (params[:poker_hand][:cards]).upcase.split
    end

    def processed_data
      @processed_data ||= []
    end

    def create_poker_cards
      processed_data.each do |data|
        poker_hand << (validates_face_and_suit(data) ? PokerParser::Card.new(data.last, data.first) : nil)
      end
    end

    def poker_hand
      @poker_hand ||= []
    end

    def validates_face_and_suit(card)
      faces.any?(card.first) && suits.any?(card.last)
    end

    def faces
      PokerParser::RANKS
    end

    def suits
      PokerParser::SUITS
    end
  end
end
