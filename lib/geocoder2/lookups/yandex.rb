require 'geocoder2/lookups/base'
require "geocoder2/results/yandex"

module Geocoder2::Lookup
  class Yandex < Base

    def name
      "Yandex"
    end

    def map_link_url(coordinates)
      "http://maps.yandex.ru/?ll=#{coordinates.reverse.join(',')}"
    end

    def query_url(query)
      "#{protocol}://geocode-maps.yandex.ru/1.x/?" + url_query_string(query)
    end

    private # ---------------------------------------------------------------

    def results(query)
      return [] unless doc = fetch_data(query)
      if err = doc['error']
        if err["status"] == 401 and err["message"] == "invalid key"
          raise_error(Geocoder2::InvalidApiKey) || warn("Invalid API key.")
        else
          warn "Yandex Geocoding API error: #{err['status']} (#{err['message']})."
        end
        return []
      end
      if doc = doc['response']['GeoObjectCollection']
        meta = doc['metaDataProperty']['Geocoder2ResponseMetaData']
        return meta['found'].to_i > 0 ? doc['featureMember'] : []
      else
        warn "Yandex Geocoding API error: unexpected response format."
        return []
      end
    end

    def query_url_params(query)
      if query.reverse_geocode?
        q = query.coordinates.reverse.join(",")
      else
        q = query.sanitized_text
      end
      {
        :geocode => q,
        :format => "json",
        :plng => "#{configuration.language}", # supports ru, uk, be
        :key => configuration.api_key
      }.merge(super)
    end
  end
end
