require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'GET #search' do
    let(:query) { 'Eiffel Tower' }
    let(:language) { 'fr' }

    before do
      allow(PlaceService).to receive(:find_or_create_place).and_return(place)
      allow(TranslationService).to receive(:translate_and_cache).and_return(translated_place)
    end

    let(:place) do
      {
        name: 'Eiffel Tower',
        city: 'Paris',
        editorial_summary: 'A famous landmark',
        current_weather: 'Sunny'
      }
    end

    let(:translated_place) do
      {
        name: 'Tour Eiffel',
        city: 'Paris',
        editorial_summary: 'Un monument célèbre',
        current_weather: 'Ensoleillé'
      }
    end

    it 'returns translated place information' do
      get :search, params: { query: query, language: language }

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      expect(json_response['name']).to eq('Tour Eiffel')
      expect(json_response['address']).to eq('Paris')
      expect(json_response['editorial_summary']).to eq('Un monument célèbre')
      expect(json_response['current_weather']).to eq('Ensoleillé')
    end
  end
end
