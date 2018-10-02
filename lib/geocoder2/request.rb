require 'geocoder2'

module Geocoder2
  module Request

    def location
      unless defined?(@location)
        if env.has_key?('HTTP_X_REAL_IP')
          @location = Geocoder2.search(env['HTTP_X_REAL_IP']).first
        elsif env.has_key?('HTTP_X_FORWARDED_FOR')
          @location = Geocoder2.search(env['HTTP_X_FORWARDED_FOR'].split(/\s*,\s*/)[0]).first
        else
          @location = Geocoder2.search(ip).first
        end
      end
      @location
    end
  end
end

if defined?(Rack) and defined?(Rack::Request)
  Rack::Request.send :include, Geocoder2::Request
end
