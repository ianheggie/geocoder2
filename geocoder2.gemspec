# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'date'
require "geocoder2/version"

Gem::Specification.new do |s|
  s.name        = "geocoder2"
  s.version     = Geocoder2::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alex Reisner", "Ian Heggie"]
  s.email       = ["ian@heggie.biz"]
  s.homepage    = "https://github.com/ianheggie/geocoder2"
  s.date        = Date.today.to_s
  s.summary     = "Complete geocoding solution for Ruby on Rails v2."
  s.description = "Provides object geocoding (by street or IP address), reverse geocoding (coordinates to street address), distance queries for ActiveRecord and Mongoid, result caching, and more. Designed for Rails but works with Sinatra and other Rack frameworks too. (clone of Geocode for older rails/ruby versions)"
  s.files       = `git ls-files`.split("\n") - %w[geocoder2.gemspec Gemfile init.rb]
  s.require_paths = ["lib"]
  s.executables = ["geocode2"]
end
