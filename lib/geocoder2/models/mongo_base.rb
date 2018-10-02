require 'geocoder2'

module Geocoder2

  ##
  # Methods for invoking Geocoder2 in a model.
  #
  module Model
    module MongoBase

      ##
      # Set attribute names and include the Geocoder2 module.
      #
      def geocoded_by(address_attr, options = {}, &block)
        geocoder2_init(
          :geocode       => true,
          :user_address  => address_attr,
          :coordinates   => options[:coordinates] || :coordinates,
          :geocode_block => block,
          :units         => options[:units],
          :method        => options[:method],
          :skip_index    => options[:skip_index] || false
        )
      end

      ##
      # Set attribute names and include the Geocoder2 module.
      #
      def reverse_geocoded_by(coordinates_attr, options = {}, &block)
        geocoder2_init(
          :reverse_geocode => true,
          :fetched_address => options[:address] || :address,
          :coordinates     => coordinates_attr,
          :reverse_block   => block,
          :units           => options[:units],
          :method          => options[:method],
          :skip_index      => options[:skip_index] || false
        )
      end

      private # ----------------------------------------------------------------

      def geocoder2_init(options)
        unless geocoder2_initialized?
          @geocoder2_options = { }
          require "geocoder2/stores/#{geocoder2_file_name}"
          include Geocoder2::Store.const_get(geocoder2_module_name)
        end
        @geocoder2_options.merge! options
      end

      def geocoder2_initialized?
        included_modules.include? Geocoder2::Store.const_get(geocoder2_module_name)
      rescue NameError
        false
      end
    end
  end
end

