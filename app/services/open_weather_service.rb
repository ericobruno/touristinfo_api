require 'httparty'

class OpenWeatherService
  include HTTParty
  base_uri ENV['OPEN_WEATHER_BASE_URL']

  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather(lat, lng)
    response = self.class.get('', query: { lat: lat, lon: lng, exclude: 'minutely,hourly', appid: @api_key })
    JSON.parse(response.body)
  end
end
