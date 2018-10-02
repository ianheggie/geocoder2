require 'geocoder2/stores/base'
require 'geocoder2/stores/mongo_base'

module Geocoder2::Store
  module Mongoid
    include Base
    include MongoBase

    def self.included(base)
      MongoBase.included_by_model(base)
    end
  end
end
