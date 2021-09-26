module PokerParser
  Card = Struct.new(:suit, :rank) do
    include Comparable

    def precedence()      = [SUITS_SCORES[suit], RANKS_SCORES[rank]]

    def rank_precedence() = RANKS_SCORES[rank]

    def suit_precedence() = SUITS_SCORES[rank]

    def <=>(other) = precedence <=> other.precedence

    def to_s() = "#{suit}#{rank}"
  end

  Hand = Struct.new(:cards) do
    def sort()         = Hand[cards.sort]

    def sort_by_rank() = Hand[cards.sort_by(&:rank_precedence)]

    def to_s() = cards.map(&:to_s).join(', ')
  end

  SUITS        = %w(S H D C).freeze
  SUITS_SCORES = SUITS.each_with_index.to_h
  RANKS        = [*2..10, 'J', 'Q', 'K', 'A'].map(&:to_s).freeze
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

  CARDS = SUITS.flat_map do |suit|
    RANKS.map { |rank| Card[suit, rank] }
  end.freeze

  def add_rank(rank, n) = RANKS[RANKS_SCORES[rank] + n]

  def royal_flush?(hand)
    hand in [
      Card[suit, '10'],
      Card[^suit, 'J'],
      Card[^suit, 'Q'],
      Card[^suit, 'K'],
      Card[^suit, 'A']
    ]
  end

  def straight_flush?(hand) = straight?(hand) && flush?(hand)

  def straight?(hand)
    hand in [
      Card[*, rank],
      Card[*, add_rank(rank, 1).to_s],
      Card[*, add_rank(rank, 2).to_s],
      Card[*, add_rank(rank, 3).to_s],
      Card[*, add_rank(rank, 4).to_s],
    ]
  end

  def flush?(hand)
    hand in [
      Card[suit, *],
      Card[^suit, *],
      Card[^suit, *],
      Card[^suit, *],
      Card[^suit, *]
    ]
  end

  def four_of_a_kind?(hand)
    hand in [
      *,
      Card[*, rank],
      Card[*, ^rank],
      Card[*, ^rank],
      Card[*, ^rank],
      *
    ]
  end

  def full_house?(hand)
    return true if hand in [
      Card[*, rank_one],
      Card[*, ^rank_one],
      Card[*, rank_two],
      Card[*, ^rank_two],
      Card[*, ^rank_two]
    ]

    hand in [
      Card[*, rank_one],
      Card[*, ^rank_one],
      Card[*, ^rank_one],
      Card[*, rank_two],
      Card[*, ^rank_two]
    ]
  end

  def three_of_a_kind?(hand)
    hand in [
      *,
      Card[*, rank],
      Card[*, ^rank],
      Card[*, ^rank],
      *
    ]
  end

  def two_pair?(hand)
    return true if hand in [
      Card[*, rank_one],
      Card[*, ^rank_one],
      *,
      Card[*, rank_two],
      Card[*, ^rank_two]
    ]

    hand in [
      *,
      Card[*, rank_one],
      Card[*, ^rank_one],
      Card[*, rank_two],
      Card[*, ^rank_two],
      *
    ]
  end

  def one_pair?(hand)
    hand in [
      *,
      Card[*, rank],
      Card[*, ^rank],
      *
    ]
  end

  def hand_score(unsorted_hand)
    hand = Hand[unsorted_hand].sort_by_rank.cards

    return SCORES[:royal_flush]     if royal_flush?(hand)
    return SCORES[:straight_flush]  if straight_flush?(hand)
    return SCORES[:four_of_a_kind]  if four_of_a_kind?(hand)
    return SCORES[:full_house]      if full_house?(hand)
    return SCORES[:flush]           if flush?(hand)
    return SCORES[:straight]        if straight?(hand)
    return SCORES[:three_of_a_kind] if three_of_a_kind?(hand)
    return SCORES[:two_pair]        if two_pair?(hand)
    return SCORES[:one_pair]        if one_pair?(hand)

    SCORES[:high_card]
  end
end
