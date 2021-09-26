module PokerParser
  # FACES = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  # SUITS = %w[S H D C].freeze

  Card = Struct.new(:suit, :rank) do
    include Comparable

    def precedence()      = [SUITS_SCORES[self.suit], RANKS_SCORES[self.rank]]
    def rank_precedence() = RANKS_SCORES[self.rank]
    def suit_precedence() = SUITS_SCORES[self.rank]

    def <=>(other) = self.precedence <=> other.precedence

    def to_s() = "#{self.suit}#{self.rank}"
  end

  Hand = Struct.new(:cards) do
    def sort()         = Hand[self.cards.sort]
    def sort_by_rank() = Hand[self.cards.sort_by(&:rank_precedence)]

    def to_s() = self.cards.map(&:to_s).join(', ')
  end

  SUITS        = %w(S H D C).freeze
  SUITS_SCORES = SUITS.each_with_index.to_h
  RANKS        = [*2..10, *%w(J Q K A)].map(&:to_s).freeze
  RANKS_SCORES = RANKS.each_with_index.to_h

  SCORES = %i(
  royal_flush
  straight_flush
  four_of_a_kind
  full_house
  flush
  straight
  three_of_a_kind
  two_pair
  one_pair
  high_card
).reverse_each.with_index(1).to_h.freeze

  CARDS = SUITS.flat_map { |s| RANKS.map { |r| Card[s, r] } }.freeze

  def hand_score(unsorted_hand)
    hand = Hand[unsorted_hand].sort_by_rank.cards

    is_straight = -> hand {
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

  # --- Testing ------

  EXAMPLES = {
    royal_flush:
      RANKS.last(5).map { Card['S', _1] },

    straight_flush:
      RANKS.first(5).map { Card['S', _1] },

    four_of_a_kind:
      [CARDS[0], *SUITS.map { Card[_1, 'A'] }],

    full_house:
      SUITS.first(3).map { Card[_1, 'A'] } +
        SUITS.first(2).map { Card[_1, 'K'] },

    flush:
      (0..RANKS.size).step(2).first(5).map { Card['S', RANKS[_1]] },

    straight:
      [Card['H', RANKS.first], *RANKS[1..4].map { Card['S', _1] }],

    three_of_a_kind:
      CARDS.first(2) +
        SUITS.first(3).map { Card[_1, 'A'] },

    two_pair:
      CARDS.first(1) +
        SUITS.first(2).flat_map { [Card[_1, 'A'], Card[_1, 'K']] },

    one_pair:
      [CARDS[10], CARDS[15], CARDS[20], *SUITS.first(2).map { Card[_1, 'A'] }],

    high_card:
      [CARDS[10], CARDS[15], CARDS[20], CARDS[5], Card['S', 'A']]
  }.freeze

  SCORE_MAP = SCORES.invert
end
