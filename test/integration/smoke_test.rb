$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[ .. .. lib]))
require 'pathname'
require 'rubygems'
require 'test/unit'
require 'geocoder2'

class SmokeTest < Test::Unit::TestCase

  def test_simple_zip_code_search
    result = Geocoder2.search "27701"
    assert_not_nil (r = result.first)
    assert_equal "Durham", r.city
    assert_equal "North Carolina", r.state
  end

  def test_simple_zip_code_search_with_ssl
    Geocoder2.configure(:use_https => true)
    result = Geocoder2.search "27701"
    assert_not_nil (r = result.first)
    assert_equal "Durham", r.city
    assert_equal "North Carolina", r.state
  ensure
    Geocoder2.configure(:use_https => false)
  end

end
