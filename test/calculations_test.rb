# encoding: utf-8
require 'test_helper'

class CalculationsTest < Test::Unit::TestCase
  def setup
    Geocoder2.configure(
      :units => :mi,
      :distances => :linear
    )
  end

  # --- degree distance ---

  def test_longitude_degree_distance_at_equator
    assert_equal 69, Geocoder2::Calculations.longitude_degree_distance(0).round
  end

  def test_longitude_degree_distance_at_new_york
    assert_equal 53, Geocoder2::Calculations.longitude_degree_distance(40).round
  end

  def test_longitude_degree_distance_at_north_pole
    assert_equal 0, Geocoder2::Calculations.longitude_degree_distance(89.98).round
  end


  # --- distance between ---

  def test_distance_between_in_miles
    assert_equal 69, Geocoder2::Calculations.distance_between([0,0], [0,1]).round
    la_to_ny = Geocoder2::Calculations.distance_between([34.05,-118.25], [40.72,-74]).round
    assert (la_to_ny - 2444).abs < 10
  end

  def test_distance_between_in_kilometers
    assert_equal 111, Geocoder2::Calculations.distance_between([0,0], [0,1], :units => :km).round
    la_to_ny = Geocoder2::Calculations.distance_between([34.05,-118.25], [40.72,-74], :units => :km).round
    assert (la_to_ny - 3942).abs < 10
  end

  def test_distance_between_in_nautical_miles
    assert_equal 60, Geocoder2::Calculations.distance_between([0,0], [0,1], :units => :nm).round
    la_to_ny = Geocoder2::Calculations.distance_between([34.05,-118.25], [40.72,-74], :units => :nm).round
    assert (la_to_ny - 2124).abs < 10
  end


  # --- geographic center ---

  def test_geographic_center_with_arrays
    assert_equal [0.0, 0.5],
      Geocoder2::Calculations.geographic_center([[0,0], [0,1]])
    assert_equal [0.0, 1.0],
      Geocoder2::Calculations.geographic_center([[0,0], [0,1], [0,2]])
  end

  def test_geographic_center_with_mixed_arguments
    p1 = [0, 0]
    p2 = Landmark.new("Some Cold Place", 0, 1)
    assert_equal [0.0, 0.5], Geocoder2::Calculations.geographic_center([p1, p2])
  end


  # --- bounding box ---

  def test_bounding_box_calculation_in_miles
    center = [51, 7] # Cologne, DE
    radius = 10 # miles
    dlon = radius / Geocoder2::Calculations.latitude_degree_distance
    dlat = radius / Geocoder2::Calculations.longitude_degree_distance(center[0])
    corners = [50.86, 6.77, 51.14, 7.23]
    assert_equal corners.map{ |i| (i * 100).round },
      Geocoder2::Calculations.bounding_box(center, radius).map{ |i| (i * 100).round }
  end

  def test_bounding_box_calculation_in_kilometers
    center = [51, 7] # Cologne, DE
    radius = 111 # kilometers (= 1 degree latitude)
    dlon = radius / Geocoder2::Calculations.latitude_degree_distance(:km)
    dlat = radius / Geocoder2::Calculations.longitude_degree_distance(center[0], :km)
    corners = [50, 5.41, 52, 8.59]
    assert_equal corners.map{ |i| (i * 100).round },
      Geocoder2::Calculations.bounding_box(center, radius, :units => :km).map{ |i| (i * 100).round }
  end

  def test_bounding_box_calculation_with_object
    center = [51, 7] # Cologne, DE
    radius = 10 # miles
    dlon = radius / Geocoder2::Calculations.latitude_degree_distance
    dlat = radius / Geocoder2::Calculations.longitude_degree_distance(center[0])
    corners = [50.86, 6.77, 51.14, 7.23]
    obj = Landmark.new("Cologne", center[0], center[1])
    assert_equal corners.map{ |i| (i * 100).round },
      Geocoder2::Calculations.bounding_box(obj, radius).map{ |i| (i * 100).round }
  end

  def test_bounding_box_calculation_with_address_string
    assert_nothing_raised do
      Geocoder2::Calculations.bounding_box("4893 Clay St, San Francisco, CA", 50)
    end
  end

  # --- random point ---

  def test_random_point_within_radius
    20.times do
      center = [51, 7] # Cologne, DE
      radius = 10 # miles
      random_point = Geocoder2::Calculations.random_point_near(center, radius)
      distance = Geocoder2::Calculations.distance_between(center, random_point)
      assert distance <= radius
    end
  end

  # --- bearing ---

  def test_compass_points
    assert_equal "N",  Geocoder2::Calculations.compass_point(0)
    assert_equal "N",  Geocoder2::Calculations.compass_point(1.0)
    assert_equal "N",  Geocoder2::Calculations.compass_point(360)
    assert_equal "N",  Geocoder2::Calculations.compass_point(361)
    assert_equal "N",  Geocoder2::Calculations.compass_point(-22)
    assert_equal "NW", Geocoder2::Calculations.compass_point(-23)
    assert_equal "S",  Geocoder2::Calculations.compass_point(180)
    assert_equal "S",  Geocoder2::Calculations.compass_point(181)
  end

  def test_bearing_between
    bearings = {
      :n => 0,
      :e => 90,
      :s => 180,
      :w => 270
    }
    points = {
      :n => [41, -75],
      :e => [40, -74],
      :s => [39, -75],
      :w => [40, -76]
    }
    directions = [:n, :e, :s, :w]
    methods = [:linear, :spherical]

    methods.each do |m|
      directions.each_with_index do |d,i|
        opp = directions[(i + 2) % 4] # opposite direction
        b = Geocoder2::Calculations.bearing_between(
          points[d], points[opp], :method => m)
        assert (b - bearings[opp]).abs < 1,
          "Bearing (#{m}) should be close to #{bearings[opp]} but was #{b}."
      end
    end
  end

  def test_spherical_bearing_to
    l = Landmark.new(*landmark_params(:msg))
    assert_equal 324, l.bearing_to([50,-85], :method => :spherical).round
  end

  def test_spherical_bearing_from
    l = Landmark.new(*landmark_params(:msg))
    assert_equal 136, l.bearing_from([50,-85], :method => :spherical).round
  end

  def test_linear_bearing_from_and_to_are_exactly_opposite
    l = Landmark.new(*landmark_params(:msg))
    assert_equal l.bearing_from([50,-86.1]), l.bearing_to([50,-86.1]) - 180
  end

  def test_extract_coordinates
    coords = [-23,47]
    l = Landmark.new("Madagascar", coords[0], coords[1])
    assert_equal coords, Geocoder2::Calculations.extract_coordinates(l)
    assert_equal coords, Geocoder2::Calculations.extract_coordinates(coords)
  end

  def test_extract_nan_coordinates
    result = Geocoder2::Calculations.extract_coordinates([ nil, nil ])
    assert_nan_coordinates?(result)

    result = Geocoder2::Calculations.extract_coordinates(nil)
    assert_nan_coordinates?(result)

    result = Geocoder2::Calculations.extract_coordinates('')
    assert_nan_coordinates?(result)

    result = Geocoder2::Calculations.extract_coordinates([ 'nix' ])
    assert_nan_coordinates?(result)

    o = Object.new
    result = Geocoder2::Calculations.extract_coordinates(o)
    assert_nan_coordinates?(result)
  end

  def test_coordinates_present
    assert Geocoder2::Calculations.coordinates_present?(3.23)
    assert !Geocoder2::Calculations.coordinates_present?(nil)
    assert !Geocoder2::Calculations.coordinates_present?(Geocoder2::Calculations::NAN)
    assert !Geocoder2::Calculations.coordinates_present?(3.23, nil)
  end

  private # ------------------------------------------------------------------

  def assert_nan_coordinates?(value)
    assert value.is_a?(Array) &&
      value.size == 2 &&
      value[0].nan? &&
      value[1].nan?,
      "Expected value to be [NaN, NaN] but was #{value}"
  end
end
