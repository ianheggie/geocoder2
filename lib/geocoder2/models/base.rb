require 'geocoder2'

module Geocoder2

  ##
  # Methods for invoking Geocoder2 in a model.
  #
  module Model
    module Base

      def geocoder2_options
        if defined?(@geocoder2_options)
          @geocoder2_options
        elsif superclass.respond_to?(:geocoder2_options)
          superclass.geocoder2_options || { }
        else
          { }
        end
      end

      def geocoded_by
        fail
      end

      def reverse_geocoded_by
        fail
      end

      private # ----------------------------------------------------------------

      def geocoder2_init(options)
        unless @geocoder2_options
          @geocoder2_options = {}
          require "geocoder2/stores/#{geocoder2_file_name}"
          include Geocoder2::Store.const_get(geocoder2_module_name)
        end
        @geocoder2_options.merge! options
      end
    end
  end
end

