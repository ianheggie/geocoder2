require 'test_helper'

class TestModeTest < Test::Unit::TestCase

  def setup
    @_original_lookup = Geocoder2.config.lookup
    Geocoder2.configure(:lookup => :test)
  end

  def teardown
    Geocoder2::Lookup::Test.reset
    Geocoder2.configure(:lookup => @_original_lookup)
  end

  def test_search_with_known_stub
    Geocoder2::Lookup::Test.add_stub("New York, NY", [mock_attributes])

    results = Geocoder2.search("New York, NY")
    result = results.first

    assert_equal 1, results.size
    mock_attributes.keys.each do |attr|
      assert_equal mock_attributes[attr], result.send(attr)
    end
  end

  def test_search_with_unknown_stub_without_default
    assert_raise ArgumentError do
      Geocoder2.search("New York, NY")
    end
  end

  def test_search_with_unknown_stub_with_default
    Geocoder2::Lookup::Test.set_default_stub([mock_attributes])

    results = Geocoder2.search("Atlantis, OC")
    result = results.first

    assert_equal 1, results.size
    mock_attributes.keys.each do |attr|
      assert_equal mock_attributes[attr], result.send(attr)
    end
  end

  private
  def mock_attributes
    coordinates = [40.7143528, -74.0059731]
    @mock_attributes ||= {
      'coordinates'  => coordinates,
      'latitude'     => coordinates[0],
      'longitude'    => coordinates[1],
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US',
    }
  end
end
