require 'geocoder2/models/base'
require 'geocoder2/models/mongo_base'

module Geocoder2
  module Model
    module MongoMapper
      include Base
      include MongoBase

      def self.included(base); base.extend(self); end

      private # --------------------------------------------------------------

      def geocoder2_file_name;   "mongo_mapper"; end
      def geocoder2_module_name; "MongoMapper"; end

      def geocoder2_init(options)
        super(options)
        if options[:skip_index] == false
          ensure_index [[ geocoder2_options[:coordinates], Mongo::GEO2D ]],
            :min => -180, :max => 180 # create 2d index
        end
      end
    end
  end
end
