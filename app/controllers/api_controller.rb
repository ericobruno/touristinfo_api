class ApiController < ApplicationController
  rescue_from StandardError, with: :handle_standard_error

  def search
    query = params[:query]
    language = params[:language] || 'en'
    normalized_query = query.downcase

    place = PlaceService.find_or_create_place(normalized_query, google_places_service, open_weather_service)
    translated_place = TranslationService.translate_and_cache(place, language, deepl_translate_service)

    render json: {
      name: translated_place[:name],
      address: translated_place[:city],
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

  def handle_standard_error(exception)
    logger.error exception.message
    logger.error exception.backtrace.join("\n")
    render json: { error: exception.message }, status: :internal_server_error
  end
end
