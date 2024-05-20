class PlaceService
    def self.find_or_create_place(normalized_query, google_places_service, open_weather_service)
      place = Place.where(normalized_query: normalized_query).first
  
      if place
        weather_info = open_weather_service.get_weather(place.lat, place.lon)
        place.current_weather = weather_info['weather'].first['description']
        return place
      end
  
      places = google_places_service.search_places(normalized_query)
      raise StandardError, 'No places found' if places['places'].empty?
  
      place_id = places['places'].first['id']
      place_details_response = google_places_service.get_place_details(place_id)
      place_details = google_places_service.extract_place_details(place_details_response)
      weather_info = open_weather_service.get_weather(place_details[:lat], place_details[:lng])
  
      Place.create(
        name: place_details[:name],
        city: place_details[:city],
        country: place_details[:country],
        description: place_details[:description],
        lat: place_details[:lat],
        lon: place_details[:lng],
        editorial_summary: place_details[:editorial_summary],
        current_weather: weather_info['weather'].first['description'],
        normalized_query: normalized_query
      )
    end
end
  