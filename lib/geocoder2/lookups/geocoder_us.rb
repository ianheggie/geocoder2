require 'geocoder2/lookups/base'
require "geocoder2/results/geocoder_us"

module Geocoder2::Lookup
  class GeocoderUs < Base

    def name
      "Geocoder2.us"
    end

    def query_url(query)
      if configuration.api_key
        "http://#{configuration.api_key}@geocoder2.us/member/service/csv/geocode?" + url_query_string(query)
      else
        "http://geocoder2.us/service/csv/geocode?" + url_query_string(query)
      end
    end

    private

    def results(query)
      return [] unless doc = fetch_data(query)
      if doc[0].to_s =~ /^(\d+)\:/
        return []
      else
        return [doc.size == 5 ? ((doc[0..1] << nil) + doc[2..4]) : doc]
      end
    end

    def query_url_params(query)
      (query.text =~ /^\d{5}(?:-\d{4})?$/ ? {:zip => query} : {:address => query.sanitized_text}).merge(super)
    end

    def parse_raw_data(raw_data)
      raw_data.chomp.split(',')
    end
  end
end

