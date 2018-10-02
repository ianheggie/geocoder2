require 'geocoder2/models/base'
require 'geocoder2/models/mongo_base'

module Geocoder2
  module Model
    module Mongoid
      include Base
      include MongoBase

      def self.included(base); base.extend(self); end

      private # --------------------------------------------------------------

      def geocoder2_file_name;   "mongoid"; end
      def geocoder2_module_name; "Mongoid"; end

      def geocoder2_init(options)
        super(options)
        if options[:skip_index] == false
          # create 2d index
          if defined?(::Mongoid::VERSION) && ::Mongoid::VERSION >= "3"
            index({ geocoder2_options[:coordinates].to_sym => '2d' }, 
                  {:min => -180, :max => 180})
          else
            index [[ geocoder2_options[:coordinates], '2d' ]],
              :min => -180, :max => 180
          end
        end
      end
    end
  end
end
