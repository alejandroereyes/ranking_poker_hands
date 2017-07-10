require "spec_helper"

RSpec.describe Poker::HandType do
  let(:hand_type) { Object.new.extend Poker::HandType }

  describe "#determine_type_of" do
    let(:royal_flush) { %w(TH QH JH AH KH) }
    let(:straight_flush) { %w(1S 2S 3S 4S 5S) }
    let(:four_of_a_kind) { %w(1H 1S 1C 1D 2H) }
    let(:full_house) { %W(KH KS KC 2H 2D) }
    let(:flush) { %w(7H 6H JH 1H AH) }
    let(:straight) { %w(1H 2H 3H 4H 5D) }
    let(:three_of_a_kind) { %w(3H 3D 3C 4D 5D) }
    let(:two_pair) { %w(1H 1D 2H 2D 8C) }
    let(:one_pair) { %w(1H 1D 2H 3H 4D) }
    let(:high_card) { %w(AS KH 7D 1C 5H) }

    it "can id a royal flush" do
      expect(hand_type.determine_type_of(royal_flush)).to eq(:royal_flush)
    end
    it "can id a straight flush" do
      expect(hand_type.determine_type_of(straight_flush)).to eq(:straight_flush)
    end
    it "can id a four of a kind" do
      expect(hand_type.determine_type_of(four_of_a_kind)).to eq(:four_of_a_kind)
    end
    it "can id a full house" do
      expect(hand_type.determine_type_of(full_house)).to eq(:full_house)
    end
    it "can id a flush" do
      expect(hand_type.determine_type_of(flush)).to eq(:flush)
    end
    it "can id a straight" do
      expect(hand_type.determine_type_of(straight)).to eq(:straight)
    end
    it "can id a three of a kind" do
      expect(hand_type.determine_type_of(three_of_a_kind)).to eq(:three_of_a_kind)
    end
    it "can id a two pair" do
      expect(hand_type.determine_type_of(two_pair)).to eq(:two_pair)
    end
    it "can id a one pair" do
      expect(hand_type.determine_type_of(one_pair)).to eq(:one_pair)
    end
    it "ids anything else as a high card" do
      expect(hand_type.determine_type_of(high_card)).to eq(:high_card)
    end
  end

  describe "#royal_flush?" do
    context "when suits are the same but values are not sequential" do
      let(:hand) { %w(9H JH QH KH JH) }
      let(:subject) { hand_type.royal_flush?(hand) }
      it { is_expected.to be false }
    end

    context "when suits are not the same but values are royal flush values" do
      let(:hand) { %w(TS JS QS KS AH) }
      let(:subject) { hand_type.royal_flush?(hand) }
      it { is_expected.to be false }
    end

    context "when suits are the same and values are sequential but not royal flush values" do
      let(:hand) { %w(1S 2S 3S 4S 5S) }
      let(:subject) { hand_type.royal_flush?(hand) }
      it { is_expected.to be false }
    end

    context "when suites are the same and values are royal flush values " do
      let(:hand) { %w(TH QH JH AH KH) }
      let(:subject) { hand_type.royal_flush?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#straight_flush?" do
    context "when suits are the same but values are not sequential" do
      let(:hand) { %w(1H 2H 3H 4H JH) }
      let(:subject) { hand_type.straight_flush?(hand) }
      it { is_expected.to be false }
    end

    context "when suits are not the same but values are sequential" do
      let(:hand) { %w(1S 2S 3S 4S 5H) }
      let(:subject) { hand_type.straight_flush?(hand) }
      it { is_expected.to be false }
    end

    context "when suits are the same AND values are sequential" do
      let(:hand) { %w(1S 2S 3S 4S 5S) }
      let(:subject) { hand_type.straight_flush?(hand) }
      it { is_expected.to be true }
    end

    context "when hand is a royal flush" do
      let(:hand) { %w(TH JH QH KH AH) }
      let(:subject) { hand_type.straight_flush?(hand) }
      it { is_expected.to be false }
    end
  end

  describe "#four_of_a_kind?" do
    context "when there are not 4 cards of equal value" do
      let(:hand) { %w(1H 1S 1D 2D 2D) }
      let(:subject) { hand_type.four_of_a_kind?(hand) }
      it { is_expected.to be false }
    end

    context "when there are 4 cards of equal value" do
      let(:hand) { %w(1H 1S 1C 1D 2H) }
      let(:subject) { hand_type.four_of_a_kind?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#full_house>" do
    context "when there are 3 of a kind but not a 2 of a kind" do
      let(:hand) { %w(KH KC KD 1C 2C) }
      let(:subject) { hand_type.full_house?(hand) }
      it { is_expected.to be false }
    end

    context "when there is 2 of a kind but not a 3 of a kind" do
      let(:hand) { %w(KH JH AK 3C 3D) }
      let(:subject) { hand_type.full_house?(hand) }
      it { is_expected.to be false }
    end

    context "when there is a 3 of a kind and a 2 of a kind" do
      let(:hand) { %W(KH KS KC 2H 2D) }
      let(:subject) { hand_type.full_house?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#flush?" do
    context "when all 5 cards are not the same suit" do
      let(:hand) { %w(7H 6H JH 1H AD) }
      let(:subject) { hand_type.flush?(hand) }
      it { is_expected.to be false }
    end

    context "when all 5 cards are of the same suit and sequential" do
      let(:hand) { %w(1S 2S 3S 4S 5S) }
      let(:subject) { hand_type.flush?(hand) }
      it { is_expected.to be false }
    end

    context "when all 5 cards are of the same suit and of royal flush values" do
      let(:hand) { %w(TH QH JH AH KH) }
      let(:subject) { hand_type.flush?(hand) }
      it { is_expected.to be false }
    end

    context "when all 5 cards are the same suit and not sequential" do
      let(:hand) { %w(7H 6H JH 1H AH) }
      let(:subject) { hand_type.flush?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#straight?" do
    context "when values are not sequential and suits differ" do
      let(:hand) { %w(1H 2H 3H 4H 6D) }
      let(:subject) { hand_type.straight?(hand) }
      it { is_expected.to be false }
    end

    context "when values are not sequential and suits are all the same" do
      let(:hand) { %w(1H 2H 3H 4H 6H) }
      let(:subject) { hand_type.straight?(hand) }
      it { is_expected.to be false }
    end

    context "when values are sequential and suits are all the same" do
      let(:hand) { %w(1H 2H 3H 4H 5H) }
      let(:subject) { hand_type.straight?(hand) }
      it { is_expected.to be false }
    end

    context "when values are sequential and suits differ" do
      let(:hand) { %w(1H 2H 3H 4H 5D) }
      let(:subject) { hand_type.straight?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#three_of_a_kind?" do
    context "when there are not 3 cards of the same value" do
      let(:hand) { %w(1H 1D 2C 2D AS) }
      let(:subject) { hand_type.three_of_a_kind?(hand) }
      it { is_expected.to be false }
    end

    context "when there are 3 cards of the same value and two cards of the same value" do
      let(:hand) { %w(3D 3D 3C 2D 2H) }
      let(:subject) { hand_type.three_of_a_kind?(hand) }
      it { is_expected.to be false }
    end

    context "when there are 3 cards of the same value and all other cards differ in value" do
      let(:hand) { %w(3H 3D 3C 4D 5D) }
      let(:subject) { hand_type.three_of_a_kind?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#two_pair?" do
    context "when there is not a pair of cards with the same value" do
      let(:hand) { %w(7H 6H 8S KD 1D) }
      let(:subject) { hand_type.two_pair?(hand) }
      it { is_expected.to be false }
    end

    context "when there is only one pair of cards of the same value" do
      let(:hand) { %w(1H 1D 2H 3H 4D) }
      let(:subject) { hand_type.two_pair?(hand) }
      it { is_expected.to be false }
    end

    context "when there is 2 pairs of card with the same value" do
      let(:hand) { %w(1H 1D 2H 2D 8C) }
      let(:subject) { hand_type.two_pair?(hand) }
      it { is_expected.to be true }
    end
  end

  describe "#one_pair?" do
    context "when there is not a pair of cards with the same value" do
      let(:hand) { %w(7H 6H 8S KD 1D) }
      let(:subject) { hand_type.one_pair?(hand) }
      it { is_expected.to be false }
    end

    context "when there is only one pair of cards of the same value" do
      let(:hand) { %w(1H 1D 2H 3H 4D) }
      let(:subject) { hand_type.one_pair?(hand) }
      it { is_expected.to be true }
    end

    context "when there is 2 pairs of card with the same value" do
      let(:hand) { %w(1H 1D 2H 2D 8C) }
      let(:subject) { hand_type.one_pair?(hand) }
      it { is_expected.to be false }
    end
  end
end
