require 'httparty'

class TranslateService
  include HTTParty
  base_uri 'https://api-free.deepl.com/v2'

  def initialize(api_key)
    @api_key = 'a7b8d508-bfae-4bb2-a4ef-bafe1916059d:fx'
  end

  def translate(texts, target_language)
    response = self.class.post('/translate',
                               body: { text: texts, target_lang: target_language }.to_json,
                               headers: { 'Content-Type' => 'application/json', 'Authorization' => "DeepL-Auth-Key #{@api_key}" })
    JSON.parse(response.body)
  end
end
