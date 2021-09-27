require 'rails_helper'
require 'support/capybara'

RSpec.describe 'Welcome Index', type: :system do
  before do
    driven_by(:cuprite)
    visit(root_path)
  end

  context 'with a Three of a Kind' do
    it 'returns Three of a Kind' do
      fill_in 'poker_hand[cards]', with: '2H 2D 2C KC QD'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Three of a Kind')
    end
  end

  context 'with a High Card' do
    it 'returns High Card' do
      fill_in 'poker_hand[cards]', with: '2H 5H 7D 8C 9S'
      click_button('Submit Poker Hand')
      expect(page).to have_text('High Card')
    end
  end

  context 'with an Ace Low Straight' do
    it 'returns Straight' do
      fill_in 'poker_hand[cards]', with: 'AH 2D 3C 4C 5D'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Straight')
    end
  end

  context 'with an Full House' do
    it 'returns Full House two low ranks and three high ranks' do
      fill_in 'poker_hand[cards]', with: '2H 3H 2D 3C 3D'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Full House')
    end

    it 'returns Full House three low ranks and two high ranks' do
      fill_in 'poker_hand[cards]', with: '5H 5D 5C AS AC'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Full House')
    end
  end

  context 'with Two Pair' do
    it 'returns Two Pair with sequential pairs' do
      fill_in 'poker_hand[cards]', with: '2H 7H 2D 3C 3D'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Two Pair')
    end

    it 'returns Two Pair with non-sequential pairs' do
      fill_in 'poker_hand[cards]', with: '5D 5C 7H AS AC'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Two Pair')
    end
  end

  context 'with a Four of a Kind' do
    it 'returns Four of a Kind' do
      fill_in 'poker_hand[cards]', with: '2H 7H 7D 7C 7S'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Four of a Kind')
    end
  end

  context 'with a Royal Flush' do
    it 'returns Straight Flush' do
      fill_in 'poker_hand[cards]', with: '10H JH QH KH AH'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Straight Flush')
    end
  end

  context 'with One Pair' do
    it 'returns One Pair' do
      fill_in 'poker_hand[cards]', with: '4H 4S KS 5D 10S'
      click_button('Submit Poker Hand')
      expect(page).to have_text('One Pair')
    end
  end

  context 'with a Flush' do
    it 'returns Flush' do
      fill_in 'poker_hand[cards]', with: '4C 7C 9C JC AC'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Flush')
    end
  end

  context 'with a valid hand and too much space' do
    it 'returns a valid hand' do
      fill_in 'poker_hand[cards]', with: '       4C        7C       9C      JC      AC          '
      click_button('Submit Poker Hand')
      expect(page).to have_text('Flush')
    end
  end

  context 'with nonsense' do
    it 'returns Invalid hand' do
      fill_in 'poker_hand[cards]', with: 'asd;kfj; asd;fklja  aks;ldfja;f ;alkjsdfj; alskdfj;'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Invalid hand')
    end
  end

  context 'with Duplicate Cards' do
    it 'returns Invalid hand' do
      fill_in 'poker_hand[cards]', with: 'QC 10C 7C 6C QC'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Invalid hand')
    end
  end

  context 'with less than 5 Cards' do
    it 'returns Invalid hand' do
      fill_in 'poker_hand[cards]', with: 'JH QH KH'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Invalid hand')
    end
  end

  context 'with a nonsensical Card' do
    it 'returns Invalid hand' do
      fill_in 'poker_hand[cards]', with: 'JH QH KH 5C asdfasdfasdf'
      click_button('Submit Poker Hand')
      expect(page).to have_text('Invalid hand')
    end
  end
end
