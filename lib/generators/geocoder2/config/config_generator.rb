require 'rails/generators'

module Geocoder2
  class ConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "This generator creates an initializer file at config/initializers, " +
         "with the default configuration options for Geocoder2."
    def add_initializer
      template "initializer.rb", "config/initializers/geocoder2.rb"
    end
  end
end

