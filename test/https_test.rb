# encoding: utf-8
require 'test_helper'

class HttpsTest < Test::Unit::TestCase

  def test_uses_https_for_secure_query
    Geocoder2.configure(:use_https => true)
    g = Geocoder2::Lookup::Google.new
    assert_match /^https:/, g.query_url(Geocoder2::Query.new("test"))
  end

  def test_uses_http_by_default
    g = Geocoder2::Lookup::Google.new
    assert_match /^http:/, g.query_url(Geocoder2::Query.new("test"))
  end
end
