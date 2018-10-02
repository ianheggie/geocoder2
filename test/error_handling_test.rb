# encoding: utf-8
require 'test_helper'

class ErrorHandlingTest < Test::Unit::TestCase

  def teardown
    Geocoder2.configure(:always_raise => [])
  end

  def test_does_not_choke_on_timeout
    # keep test output clean: suppress timeout warning
    orig = $VERBOSE; $VERBOSE = nil
    Geocoder2::Lookup.all_services_except_test.each do |l|
      Geocoder2.configure(:lookup => l)
      set_api_key!(l)
      assert_nothing_raised { Geocoder2.search("timeout") }
    end
  ensure
    $VERBOSE = orig
  end

  def test_always_raise_timeout_error
    Geocoder2.configure(:always_raise => [TimeoutError])
    Geocoder2::Lookup.all_services_except_test.each do |l|
      lookup = Geocoder2::Lookup.get(l)
      set_api_key!(l)
      assert_raises TimeoutError do
        lookup.send(:results, Geocoder2::Query.new("timeout"))
      end
    end
  end

  def test_always_raise_socket_error
    Geocoder2.configure(:always_raise => [SocketError])
    Geocoder2::Lookup.all_services_except_test.each do |l|
      lookup = Geocoder2::Lookup.get(l)
      set_api_key!(l)
      assert_raises SocketError do
        lookup.send(:results, Geocoder2::Query.new("socket_error"))
      end
    end
  end
end
