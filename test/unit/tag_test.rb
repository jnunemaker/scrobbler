require File.dirname(__FILE__) + '/../test_helper.rb'

class TestTag < Test::Unit::TestCase
  def setup
    @tag = Scrobbler::Tag.new('rock')
  end
  
  test 'should be able to find the top tags for the entire system' do
    assert_equal(249, Scrobbler::Tag.top_tags.size)
    assert_equal('rock', Scrobbler::Tag.top_tags.first.name)
    assert_equal('878660', Scrobbler::Tag.top_tags.first.count)
    assert_equal('http://www.last.fm/tag/rock', Scrobbler::Tag.top_tags.first.url)
  end
  
  test 'should require name' do
    assert_raise(ArgumentError) { Scrobbler::Tag.new('') }
  end
  
  test 'should have name' do
    assert_equal('rock', @tag.name)
  end
  
  test 'should have api path' do
    assert_equal('/1.0/tag/rock', @tag.api_path)
  end
  
  test 'should escape api path' do
    assert_equal('/1.0/tag/rock+and+roll', Scrobbler::Tag.new('rock and roll').api_path)
  end
  
  test 'should be able to find top artists for a tag' do
    assert_equal(6, @tag.top_artists.size)
    assert_equal('Red Hot Chili Peppers', @tag.top_artists.first.name)
    assert_equal('5740', @tag.top_artists.first.count)
    assert_equal('yes', @tag.top_artists.first.streamable)
    assert_equal('8bfac288-ccc5-448d-9573-c33ea2aa5c30', @tag.top_artists.first.mbid)
    assert_equal('http://www.last.fm/music/Red+Hot+Chili+Peppers', @tag.top_artists.first.url)
    assert_equal('http://static3.last.fm/storable/image/184200/small.jpg', @tag.top_artists.first.thumbnail)
    assert_equal('http://panther1.last.fm/proposedimages/sidebar/6/1274/552019.jpg', @tag.top_artists.first.image)
  end
  
  test 'should be able to find top albums for a tag' do
    assert_equal(3, @tag.top_albums.size)
    assert_equal('Californication', @tag.top_albums.first.name)
    assert_equal('Red Hot Chili Peppers', @tag.top_albums.first.artist)
    assert_equal('8bfac288-ccc5-448d-9573-c33ea2aa5c30', @tag.top_albums.first.artist_mbid)
    assert_equal('http://www.last.fm/music/Red+Hot+Chili+Peppers/Californication', @tag.top_albums.first.url)
    assert_equal('http://panther1.last.fm/coverart/50x50/4791.jpg', @tag.top_albums.first.image(:small))
    assert_equal('http://cdn.last.fm/coverart/130x130/4791.jpg', @tag.top_albums.first.image(:medium))
    assert_equal('http://cdn.last.fm/coverart/300x300/4791.jpg', @tag.top_albums.first.image(:large))
  end
  
  test 'should be able to find top tracks for a tag' do
    assert_equal(3, @tag.top_tracks.size)
    first = @tag.top_tracks.first
    assert_equal('Once Upon a Time', first.name)
    assert_equal('1076', first.count)
    assert_equal('no', first.streamable)
    assert_equal('Frank Zappa', first.artist)
    assert_equal('e20747e7-55a4-452e-8766-7b985585082d', first.artist_mbid)
    assert_equal('http://www.last.fm/music/Frank+Zappa/_/Once+Upon+a+Time', first.url)
    assert_equal('http://ec1.images-amazon.com/images/P/B0000009TN.01._SCMZZZZZZZ_.jpg', first.thumbnail)
    assert_equal('http://ec1.images-amazon.com/images/P/B0000009TN.01._SCMZZZZZZZ_.jpg', first.image)
  end
end