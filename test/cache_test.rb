# encoding: utf-8
require 'test_helper'

class CacheTest < Test::Unit::TestCase

  def test_second_occurrence_of_request_is_cache_hit
    Geocoder2.configure(:cache => {})
    Geocoder2::Lookup.all_services_except_test.each do |l|
      Geocoder2.configure(:lookup => l)
      set_api_key!(l)
      results = Geocoder2.search("Madison Square Garden")
      assert !results.first.cache_hit,
        "Lookup #{l} returned erroneously cached result."
      results = Geocoder2.search("Madison Square Garden")
      assert results.first.cache_hit,
        "Lookup #{l} did not return cached result."
    end
  end

  def test_google_over_query_limit_does_not_hit_cache
    Geocoder2.configure(:cache => {})
    Geocoder2.configure(:lookup => :google)
    set_api_key!(:google)
    Geocoder2.configure(:always_raise => :all)
    assert_raises Geocoder2::OverQueryLimitError do
      Geocoder2.search("over limit")
    end
    lookup = Geocoder2::Lookup.get(:google)
    assert_equal false, lookup.instance_variable_get(:@cache_hit)
    assert_raises Geocoder2::OverQueryLimitError do
      Geocoder2.search("over limit")
    end
    assert_equal false, lookup.instance_variable_get(:@cache_hit)
  end
end
