require 'httparty'

class TranslateService
  include HTTParty
  base_uri 'https://api-free.deepl.com/v2'

  def initialize(api_key)
    @api_key = api_key
  end

  def translate(texts, target_language)
    response = self.class.post('/translate',
                               body: { text: texts, target_lang: target_language }.to_json,
                               headers: { 'Content-Type' => 'application/json', 'Authorization' => "DeepL-Auth-Key #{@api_key}" })
    JSON.parse(response.body)
  end
end
