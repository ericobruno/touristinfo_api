class OpenWeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5/weather'

  def initialize(api_key)
    @api_key = api_key
  end

  def get_weather(lat, lng)
    response = self.class.get('', query: { lat: lat, lon: lng, exclude: 'minutely,hourly', appid: @api_key })
    JSON.parse(response.body)
  end
end