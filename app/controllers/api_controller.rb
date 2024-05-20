class ApiController < ApplicationController
    rescue_from StandardError, with: :handle_standard_error
  
    def search
      query = params[:query]
      language = params[:language] || 'en'
      normalized_query = query.downcase
  
      # Verifica se já existe um cache para o local
      place = Place.where(normalized_query: normalized_query).first
      if place
        weather_info = open_weather_service.get_weather(place.lat, place.lon)
        translated_place = place.translations[language] || translate_and_cache(place, language)
        translated_place[:current_weather] = deepl_translate_service.translate(weather_info['weather'].first['description'], language)['translations'].first['text']
        
        render json: {
          name: translated_place[:name],
          city: translated_place[:city],
          editorial_summary: translated_place[:editorial_summary],
          current_weather: translated_place[:current_weather],
          review: translated_place[:review]
        } and return
      end
  
      # Busca informações no Google Places
      places = google_places_service.search_places(query)
      if places['places'].empty?
        puts "No places found for query: #{query}"
        render json: { error: 'No places found' }, status: :not_found and return
      end
      place_id = places['places'].first['id']
  
      # Obtém detalhes do lugar usando o place_id
      place_details_response = google_places_service.get_place_details(place_id)
      place_details = google_places_service.extract_place_details(place_details_response)
      
      # Busca informações do tempo no Open Weather
      weather_info = open_weather_service.get_weather(place_details[:lat], place_details[:lng])
  
      # Cria o objeto Place
      place = Place.create(
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
      
  
      # Traduz e armazena a tradução no banco
      translated_place = translate_and_cache(place, language)
      translated_place[:current_weather] = deepl_translate_service.translate(weather_info['weather'].first['description'], language)['translations'].first['text']
  
      render json: {
        name: translated_place[:name],
        adress: translated_place[:city],
        editorial_summary: translated_place[:editorial_summary],
        current_weather: translated_place[:current_weather]
      }
    end 
  
    private
  
    def google_places_service
      @google_places_service ||= GooglePlacesService.new(ENV['GOOGLE_PLACES_API_KEY'])
    end
  
    def open_weather_service
      @open_weather_service ||= OpenWeatherService.new(ENV['OPEN_WEATHER_API_KEY'])
    end
  
    def deepl_translate_service
      @deepl_translate_service ||= TranslateService.new(ENV['DEEPL_API_KEY'])
    end
  
    def translate_and_cache(place, language)
      translated_name = deepl_translate_service.translate(place.name, language)
      translated_city = deepl_translate_service.translate(place.city, language)
      translated_description = deepl_translate_service.translate(place.description, language)
      translated_summary = deepl_translate_service.translate(place.editorial_summary, language)
      translated_current_weather = deepl_translate_service.translate(place.current_weather, language)
      
  
      if translated_name['translations'].nil? || translated_city['translations'].nil? || translated_description['translations'].nil? || translated_summary['translations'].nil? || translated_current_weather['translations'].nil?
        raise "Translation failed for place #{place.id}"
      end
  
      place.translations ||= {}
      place.translations[language] = {
        name: translated_name['translations'].first['text'],
        city: translated_city['translations'].first['text'],
        description: translated_description['translations'].first['text'],
        editorial_summary: translated_summary['translations'].first['text'],
        current_weather: translated_current_weather['translations'].first['text']
      }
  
      if place.save
        place.translations[language]
      else
        raise "Failed to save translations for place #{place.id}"
      end
    end
  
    def handle_standard_error(exception)
      logger.error exception.message
      logger.error exception.backtrace.join("\n")
      render json: { error: exception.message }, status: :internal_server_error
    end
end
  