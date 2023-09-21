require "rails_helper"

RSpec.describe "Card Display", type: :request do
  before do
    fake_response = File.read(fixture_data)

    uri = URI("https://api.scryfall.com/cards/search?format=json&include_extras=false&include_multilingual=false&include_variations=false&order=name&q=c%3Awhite+mv%3D1&unique=cards&page=1&per_page=1")
    allow(Net::HTTP).to receive(:get).with(uri).and_return(fake_response)
  end

  describe '#index' do
    context 'on success' do
      let!(:fixture_data) { "spec/fixtures/magic_card_index.json" }

      it 'renders the index template' do
        get '/'

        expect(response).to render_template(:index)
      end
    end

    context 'on error' do
      let!(:fixture_data) { "spec/fixtures/magic_card_error.json" }

      it 'responds with a 422' do
        get '/'

        expect(response.status).to be(422)
      end
    end
  end
end
