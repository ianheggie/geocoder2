require 'geocoder2/lookups/base'
require "geocoder2/results/esri"

module Geocoder2::Lookup
  class Esri < Base
    
    def name
      "Esri"
    end

    def query_url(query)
      search_keyword = query.reverse_geocode? ? "reverseGeocode" : "find"

      "#{protocol}://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/#{search_keyword}?" +
        url_query_string(query)
    end

    private # ---------------------------------------------------------------

    def results(query)
      return [] unless doc = fetch_data(query)

      if (!query.reverse_geocode?)
        return [] if doc['locations'].empty?
      end

      if (doc['error'].nil?)
        return [ doc ]
      else
        return []
      end
    end

    def query_url_params(query)
      params = {
        :f => "pjson",
        :outFields => "*"
      }
      if query.reverse_geocode?
        params[:location] = query.coordinates.reverse.join(',')
      else
        params[:text] = query.sanitized_text
      end
      params.merge(super)
    end

  end
end
