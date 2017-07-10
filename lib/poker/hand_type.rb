require_relative "cards"
module Poker
  module HandType

    DETERMINING_METHODS = %w(
      royal_flush? straight_flush? four_of_a_kind? full_house?
      flush? straight? three_of_a_kind? two_pair? one_pair? high_card
    ).freeze

    ROYAL_FLUSH_VALUES = Poker::Cards::VALUES[-5..-1]

    def determine_type_of(hand)
      DETERMINING_METHODS.select { |method| self.send(method, (hand)) }.first.gsub("?", "").to_sym
    end

    def royal_flush?(hand)
      return false unless royal_flush_values?(hand)
      return false unless one_suit_for?(hand)
      true
    end

    def straight_flush?(hand)
      return false unless sequential?(hand)
      return false unless one_suit_for?(hand)
      return false if royal_flush_values?(hand)
      true
    end

    def four_of_a_kind?(hand)
      of_n_kind?(4, hand)
    end

    def full_house?(hand)
      of_n_kind?(3, hand) && of_n_kind?(2, hand)
    end

    def flush?(hand)
      return false if straight_flush?(hand)
      return false if royal_flush?(hand)
      one_suit_for?(hand)
    end

    def straight?(hand)
      return false if one_suit_for?(hand)
      sequential?(hand)
    end

    def three_of_a_kind?(hand)
      of_n_kind?(3, hand) && !of_n_kind?(2, hand)
    end

    def two_pair?(hand)
      of_n_pairs?(2, hand)
    end

    def one_pair?(hand)
      of_n_pairs?(1, hand)
    end

    def high_card(hand)
      Poker::Cards::VALUES[card_values_of(hand).last]
    end

    private

    def of_n_pairs?(n, hand, pair_size: 2)
      group_by_value(hand).select { |group, amount| amount.size == pair_size }.size == n
    end

    def of_n_kind?(n, hand)
      group_by_value(hand).any? { |group, amount| amount.size == n }
    end

    def group_by_value(hand)
      card_values_of(hand).group_by { |value| value }
    end

    def royal_flush_values?(hand)
      hand.all? { |card| ROYAL_FLUSH_VALUES.member?(value_of(card)) }
    end

    def one_suit_for?(hand)
      uniq_suits(hand).count == 1
    end

    def sequential?(hand)
      values = card_values_of(hand)
      first = values.first
      last = values.last
      sequential_arr = (first..last).to_a

      sequential_arr.size == 5 && values == sequential_arr
    end

    def card_values_of(hand)
      hand.map { |card| Poker::Cards::VALUES.index(value_of(card)) }.sort
    end

    def uniq_suits(hand)
      hand.map { |card| suit_of(card) }.uniq
    end

    def value_of(card)
      card.size == 3 ? card[0..1] : card[0]
    end

    def suit_of(card)
      card[-1]
    end
  end
end
