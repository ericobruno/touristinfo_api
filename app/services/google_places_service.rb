require 'httparty'

class GooglePlacesService
  include HTTParty
  base_uri 'https://places.googleapis.com/v1'

  def initialize(api_key)
    @api_key = 'AIzaSyCwLLAiQxVS87MYvLyBqRcj3_P7rFUI_Ig'
  end

  def search_places(query)
    options = {
      body: {
        textQuery: query
      }.to_json,
      headers: {
        'Content-Type' => 'application/json',
        'X-Goog-Api-Key' => @api_key,
        'X-Goog-FieldMask' => 'places.id'
      }
    }

    response = self.class.post('/places:searchText', options)
    puts "search_places response: #{response.body}"
    JSON.parse(response.body)
  end

  def get_place_details(place_id)
    options = {
      headers: {
        'Content-Type' => 'application/json',
        'X-Goog-Api-Key' => @api_key,
        'X-Goog-FieldMask' => 'displayName,formattedAddress,location,types,editorialSummary'
      }
    }

    response = self.class.get("/places/#{place_id}", options)
    puts "get_place_details response: #{response.body}"
    JSON.parse(response.body)
  end

  def extract_place_details(place)
    details = {
      name: place.dig('displayName', 'text') || 'N/A',
      city: place.dig('formattedAddress')&.split(',')&.first&.strip || 'N/A',
      country: place.dig('formattedAddress')&.split(',')&.last&.strip || 'N/A',
      description: place.dig('types')&.join(', ') || 'N/A',
      lat: place.dig('location', 'latitude') || 0.0,
      lng: place.dig('location', 'longitude') || 0.0,
      editorial_summary: place.dig('editorialSummary', 'text') || 'N/A'
    }

    puts "extract_place_details: #{details.inspect}"
    details
  end
end