require "geocoder2/configuration"
require "geocoder2/query"
require "geocoder2/calculations"
require "geocoder2/exceptions"
require "geocoder2/cache"
require "geocoder2/request"
require "geocoder2/lookup"
require "geocoder2/models/active_record" if defined?(::ActiveRecord)
require "geocoder2/models/mongoid" if defined?(::Mongoid)
require "geocoder2/models/mongo_mapper" if defined?(::MongoMapper)

module Geocoder2
  extend self

  ##
  # Search for information about an address or a set of coordinates.
  #
  def search(query, options = {})
    query = Geocoder2::Query.new(query, options) unless query.is_a?(Geocoder2::Query)
    query.blank? ? [] : query.execute
  end

  ##
  # Look up the coordinates of the given street or IP address.
  #
  def coordinates(address, options = {})
    if (results = search(address, options)).size > 0
      results.first.coordinates
    end
  end

  ##
  # Look up the address of the given coordinates ([lat,lon])
  # or IP address (string).
  #
  def address(query, options = {})
    if (results = search(query, options)).size > 0
      results.first.address
    end
  end

  ##
  # The working Cache object, or +nil+ if none configured.
  #
  def cache
    warn "WARNING: Calling Geocoder2.cache is DEPRECATED. The #cache method now belongs to the Geocoder2::Lookup object."
    Geocoder2::Lookup.get(Geocoder2.config.lookup).cache
  end
end

# load Railtie if Rails exists
if defined?(Rails)
  require "geocoder2/railtie"
  Geocoder2::Railtie.insert
end
