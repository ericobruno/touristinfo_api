Este projeto é uma API que integra diferentes serviços para fornecer informações sobre pontos turísticos, incluindo um resumo do clima atual e tradução para o idioma desejado. A aplicação foi desenvolvida utilizando Ruby on Rails e MongoDB. 

Consome a API do Google Places para obter informações sobre pontos turísticos. 
** https://developers.google.com/maps/documentation/places/web-service/op-overview?hl=pt-br

Consome a API do OpenWeather para obter informações sobre o clima atual nos pontos turísticos pesquisados. 
** https://openweathermap.org/current

Consome a API do DeepL para traduzir as informações dos pontos turísticos para o idioma desejado.
** https://developers.deepl.com/docs/v/pt-pt
** https://developers.deepl.com/docs/v/pt-pt/resources/supported-languages#target-languages


A API permite a busca de informações sobre pontos turísticos utilizando os parâmetros fornecidos pelo usuário.

Exemplo de request: http://localhost:3000/api/search?query=praia%20da%20pipa%20rn&language=pt-br

Onde 'Praia da Pipa' é o ponto pesquisado e 'pt-br' é o parametro do idioma esperado.

Exemplo de resposta: 

{
  "name": "Praia da Pipa",
  "address": "Praia da Pipa",
  "editorial_summary": "Esta popular praia de areia branca tem falésias e surf, além de restaurantes, bares e hotéis.",
  "current_weather": "céu limpo"
}



* Ruby: "3.2.2"

* Requerimentos: 

-Docker
-Docker Compose

* Configuração

-Clone o repositório do GitHub.

Crie um arquivo '.env' na raiz do projeto, Exemplo:

GOOGLE_PLACES_API_KEY=SuaChaveGooglePlaces
OPEN_WEATHER_API_KEY=SuaChaveOpenWeather
DEEPL_API_KEY=SuaChaveDeepL

* Executar a aplicação
- docker compose up --build

* Criação do Banco de dados
-O banco de dados MongoDB será configurado automaticamente pelo Docker Compose. 
* Inicialização do Banco de dados
-O banco de dados será inicializado automaticamente pelo Docker Compose.

* Executar os testes
- docker-compose run test

Controller e Services::

* ApiController:
Gerencia a busca por pontos turísticos, usando os serviços do Google Places, OpenWeather e DeepL para obter, traduzir e retornar as informações sobre os locais.

* GooglePlacesService
Faz a integração com a API do Google Places para buscar e obter detalhes de pontos turísticos.

* OpenWeatherService
Faz a integração com a API do OpenWeather para obter informações meteorológicas atuais de locais específicos.

* PlaceService
Busca ou cria registros de pontos turísticos no banco de dados, utilizando os serviços do GooglePlacesService e OpenWeatherService para obter os dados.

* TranslateService
Faz a integração com a API do DeepL para traduzir textos para o idioma desejado.

* TranslationService
Gerencia a tradução e o cache das informações de pontos turísticos, utilizando o TranslateService para realizar as traduções.
