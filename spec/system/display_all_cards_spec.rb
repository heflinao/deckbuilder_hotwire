require "rails_helper"

RSpec.describe "Card Display", type: :system do
  describe 'homepage' do
    before do
      fake_response = File.read("spec/fixtures/magic_card_index.json")

      uri = URI("https://api.scryfall.com/cards/search?format=json&include_extras=false&include_multilingual=false&include_variations=false&order=name&q=c%3Awhite+mv%3D1&unique=cards&page=1&per_page=1")
      allow(Net::HTTP).to receive(:get).with(uri).and_return(fake_response)
    end

    it 'renders the the name of the card' do
      visit '/'

      expect(page).to have_text("Abu Ja'far")
    end
  end
end
