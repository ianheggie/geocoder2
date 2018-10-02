require 'geocoder2'
require 'geocoder2/models/active_record'

module Geocoder2
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      initializer 'geocoder2.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          Geocoder2::Railtie.insert
        end
      end
      rake_tasks do
        load "tasks/geocoder2.rake"
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(::ActiveRecord)
        ::ActiveRecord::Base.extend(Model::ActiveRecord)
      end
    end
  end
end
