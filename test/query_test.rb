# encoding: utf-8
require 'test_helper'

class QueryTest < Test::Unit::TestCase

  def test_ip_address_detection
    assert Geocoder2::Query.new("232.65.123.94").ip_address?
    assert Geocoder2::Query.new("666.65.123.94").ip_address? # technically invalid
    assert Geocoder2::Query.new("::ffff:12.34.56.78").ip_address?
    assert !Geocoder2::Query.new("232.65.123.94.43").ip_address?
    assert !Geocoder2::Query.new("232.65.123").ip_address?
    assert !Geocoder2::Query.new("::ffff:123.456.789").ip_address?
    assert !Geocoder2::Query.new("Test\n232.65.123.94").ip_address?
  end

  def test_blank_query_detection
    assert Geocoder2::Query.new(nil).blank?
    assert Geocoder2::Query.new("").blank?
    assert Geocoder2::Query.new("\t  ").blank?
    assert !Geocoder2::Query.new("a").blank?
    assert !Geocoder2::Query.new("Москва").blank? # no ASCII characters
    assert !Geocoder2::Query.new("\na").blank?

    assert Geocoder2::Query.new(nil, :params => {}).blank?
    assert !Geocoder2::Query.new(nil, :params => {:woeid => 1234567}).blank?
  end

  def test_blank_query_detection_for_coordinates
    assert Geocoder2::Query.new([nil,nil]).blank?
    assert Geocoder2::Query.new([87,nil]).blank?
  end

  def test_coordinates_detection
    assert Geocoder2::Query.new("51.178844,5").coordinates?
    assert Geocoder2::Query.new("51.178844, -1.826189").coordinates?
    assert !Geocoder2::Query.new("232.65.123").coordinates?
    assert !Geocoder2::Query.new("Test\n51.178844, -1.826189").coordinates?
  end

  def test_loopback_ip_address
    assert Geocoder2::Query.new("0.0.0.0").loopback_ip_address?
    assert Geocoder2::Query.new("127.0.0.1").loopback_ip_address?
    assert !Geocoder2::Query.new("232.65.123.234").loopback_ip_address?
    assert !Geocoder2::Query.new("127 Main St.").loopback_ip_address?
    assert !Geocoder2::Query.new("John Doe\n127 Main St.\nAnywhere, USA").loopback_ip_address?
  end

  def test_sanitized_text_with_array
    q = Geocoder2::Query.new([43.1313,11.3131])
    assert_equal "43.1313,11.3131", q.sanitized_text
  end
end
