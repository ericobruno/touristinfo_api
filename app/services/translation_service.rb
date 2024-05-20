class TranslationService
    def self.translate_and_cache(place, language, deepl_translate_service)
      translated_fields = translate_fields(place, language, deepl_translate_service)
  
      raise StandardError, "Translation failed for place #{place.id}" if translated_fields.values.any?(&:nil?)
  
      place.translations ||= {}
      place.translations[language] = translated_fields
  
      raise StandardError, "Failed to save translations for place #{place.id}" unless place.save
      place.translations[language]
    end
  
    private
  
    def self.translate_fields(place, language, deepl_translate_service)
      fields_to_translate = {
        name: place.name,
        city: place.city,
        description: place.description,
        editorial_summary: place.editorial_summary,
        current_weather: place.current_weather
      }
  
     
      translations_response = deepl_translate_service.translate(fields_to_translate.values, language)
  
      raise StandardError, "Translation response is nil" if translations_response['translations'].nil?
  
      translated_fields = fields_to_translate.keys.zip(translations_response['translations'].map { |t| t['text'] }).to_h
  
      translated_fields
    end
end
  