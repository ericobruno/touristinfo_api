class Place
    include Mongoid::Document
  
    field :name, type: String
    field :city, type: String
    field :country, type: String
    field :description, type: String
    field :lat, type: Float
    field :lon, type: Float
    field :editorial_summary, type: String
    field :current_weather, type: String
    field :normalized_query, type: String
    field :translations, type: Hash, default: {}
end
  