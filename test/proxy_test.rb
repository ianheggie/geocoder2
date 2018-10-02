# encoding: utf-8
require 'test_helper'

class ProxyTest < Test::Unit::TestCase

  def test_uses_proxy_when_specified
    Geocoder2.configure(:http_proxy => 'localhost')
    lookup = Geocoder2::Lookup::Google.new
    assert lookup.send(:http_client).proxy_class?
  end

  def test_doesnt_use_proxy_when_not_specified
    lookup = Geocoder2::Lookup::Google.new
    assert !lookup.send(:http_client).proxy_class?
  end

  def test_exception_raised_on_bad_proxy_url
    Geocoder2.configure(:http_proxy => ' \\_O< Quack Quack')
    assert_raise Geocoder2::ConfigurationError do
      Geocoder2::Lookup::Google.new.send(:http_client)
    end
  end

  def test_accepts_proxy_with_http_protocol
    Geocoder2.configure(:http_proxy => 'http://localhost')
    lookup = Geocoder2::Lookup::Google.new
    assert lookup.send(:http_client).proxy_class?
  end

  def test_accepts_proxy_with_https_protocol
    Geocoder2.configure(:https_proxy => 'https://localhost')
    Geocoder2.configure(:use_https => true)
    lookup = Geocoder2::Lookup::Google.new
    assert lookup.send(:http_client).proxy_class?
  end
end
