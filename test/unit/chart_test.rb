require File.dirname(__FILE__) + '/../test_helper.rb'

class TestChart < Test::Unit::TestCase

  def setup
    @chart = Scrobbler::Chart.new('1108296002', '1108900802')
  end
  
  test 'should require from' do
    assert_raise(ArgumentError) { Scrobbler::Chart.new('', '1108900802') }
  end
  
  test 'should require to' do
    assert_raise(ArgumentError) { Scrobbler::Chart.new('1108296002', '') }
  end
  
  test 'should be able to parse to and from that are unix timestamp strings' do
    chart = Scrobbler::Chart.new('1108296002', '1108900802')
    assert_equal(1108296002, chart.from)
    assert_equal(1108900802, chart.to)
  end
  
  test 'should be able to parse to and from that are unix timestamp fixnums' do
    chart = Scrobbler::Chart.new(1108296002, 1108900802)
    assert_equal(1108296002, chart.from)
    assert_equal(1108900802, chart.to)
  end
  
  test 'should be able to parse to and from that are times' do
    chart = Scrobbler::Chart.new(Time.at(1108296002), Time.at(1108900802))
    assert_equal(1108296002, chart.from)
    assert_equal(1108900802, chart.to)
  end
end