module PokerParser
  Card = Struct.new(:suit, :rank) do
    include Comparable

    def precedence
      [SUITS_SCORES[suit], RANKS_SCORES[rank]]
    end

    def rank_precedence
      RANKS_SCORES[rank]
    end

    def suit_precedence
      SUITS_SCORES[rank]
    end

    def <=>(other)
      precedence <=> other.precedence
    end

    def to_s
      "#{suit}#{rank}"
    end
  end

  Hand = Struct.new(:cards) do
    def sort
      Hand[cards.sort]
    end

    def sort_by_rank
      Hand[cards.sort_by(&:rank_precedence)]
    end

    def to_s
      cards.map(&:to_s).join(', ')
    end
  end

  SUITS = %w[S H D C].freeze
  SUITS_SCORES = SUITS.each_with_index.to_h
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  RANKS_SCORES = RANKS.each_with_index.to_h

  SCORES = {
    royal_flush: 'Royal Flush',
    straight_flush: 'Straight Flush',
    four_of_a_kind: 'Four of a Kind',
    full_house: 'Full House',
    flush: 'Flush',
    straight: 'Straight',
    three_of_a_kind: 'Three of a Kind',
    two_pair: 'Two Pair',
    one_pair: 'One Pair',
    high_card: 'High Card'
  }.freeze

  CARDS = SUITS.flat_map { |s| RANKS.map { |r| Card[s, r] } }.freeze

  def hand_score(unsorted_hand)
    hand = Hand[unsorted_hand].sort_by_rank.cards

    is_straight = lambda { |hand|
      hand
        .map { RANKS_SCORES[_1.rank] }
        .sort
        .each_cons(2)
        .all? { |a, b| b - a == 1 }
    }

    return SCORES[:royal_flush] if hand in [
      Card[s, '10'], Card[^s, 'J'], Card[^s, 'Q'], Card[^s, 'K'], Card[^s, 'A']
    ]

    return SCORES[:straight_flush] if is_straight[hand] && hand in [
      Card[s, *], Card[^s, *], Card[^s, *], Card[^s, *], Card[^s, *]
    ]

    return SCORES[:four_of_a_kind] if hand in [
      *, Card[*, r], Card[*, ^r], Card[*, ^r], Card[*, ^r], *
    ]

    return SCORES[:full_house] if hand in [
      Card[*, r1], Card[*, ^r1], Card[*, ^r1], Card[*, r2], Card[*, ^r2]
    ]

    return SCORES[:full_house] if hand in [
      Card[*, r1], Card[*, ^r1], Card[*, r2], Card[*, ^r2], Card[*, ^r2]
    ]

    return SCORES[:flush] if hand in [
      Card[s, *], Card[^s, *], Card[^s, *], Card[^s, *], Card[^s, *]
    ]

    return SCORES[:straight] if is_straight[hand]

    return SCORES[:three_of_a_kind] if hand in [
      *, Card[*, r], Card[*, ^r], Card[*, ^r], *
    ]

    return SCORES[:two_pair] if hand in [
      *, Card[*, r1], Card[*, ^r1], Card[*, r2], Card[*, ^r2], *
    ]

    return SCORES[:two_pair] if hand in [
      Card[*, r1], Card[*, ^r1], *, Card[*, r2], Card[*, ^r2]
    ]

    return SCORES[:one_pair] if hand in [
      *, Card[*, r], Card[*, ^r], *
    ]

    SCORES[:high_card]
  end
end
