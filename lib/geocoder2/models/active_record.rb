require 'geocoder2/models/base'

module Geocoder2
  module Model
    module ActiveRecord
      include Base

      ##
      # Set attribute names and include the Geocoder2 module.
      #
      def geocoded_by(address_attr, options = {}, &block)
        geocoder2_init(
          :geocode       => true,
          :user_address  => address_attr,
          :latitude      => options[:latitude]  || :latitude,
          :longitude     => options[:longitude] || :longitude,
          :geocode_block => block,
          :units         => options[:units],
          :method        => options[:method]
        )
      end

      ##
      # Set attribute names and include the Geocoder2 module.
      #
      def reverse_geocoded_by(latitude_attr, longitude_attr, options = {}, &block)
        geocoder2_init(
          :reverse_geocode => true,
          :fetched_address => options[:address] || :address,
          :latitude        => latitude_attr,
          :longitude       => longitude_attr,
          :reverse_block   => block,
          :units         => options[:units],
          :method        => options[:method]
        )
      end


      private # --------------------------------------------------------------

      def geocoder2_file_name;   "active_record"; end
      def geocoder2_module_name; "ActiveRecord"; end
    end
  end
end

