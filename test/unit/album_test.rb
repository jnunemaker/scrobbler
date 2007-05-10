require File.dirname(__FILE__) + '/../test_helper.rb'

class TestAlbum < Test::Unit::TestCase

  def setup
    @album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts')
  end
  
  test 'should require the artist name' do
    assert_raises(ArgumentError) { Scrobbler::Album.new('', 'Some Hearts') }
  end
  
  test 'should require the track name' do
    assert_raises(ArgumentError) { Scrobbler::Album.new('Carrie Underwood', '') }
  end
  
  test 'should know the artist' do
    assert_equal('Carrie Underwood', @album.artist)
  end
  
  test "should know it's name" do
    assert_equal('Some Hearts', @album.name)
  end
  
  test 'should have correct api path' do
    assert_equal("/1.0/album/Carrie+Underwood/Some+Hearts", @album.api_path)
  end
  
  test 'should be able to load album info' do
    @album.load_info
    assert_equal('18589', @album.reach)
    assert_equal('http://www.last.fm/music/Carrie+Underwood/Some+Hearts', @album.url)
    assert_equal(Time.mktime(2005, 11, 15, 00, 00, 00), @album.release_date)
    assert_equal(14, @album.tracks.size)
    assert_equal('Wasted', @album.tracks.first.name)
    assert_equal('http://www.last.fm/music/Carrie+Underwood/_/Wasted', @album.tracks.first.url)
    assert_equal('6738', @album.tracks.first.reach)
  end
  
  test 'should be able to find an ablum' do
    album = Scrobbler::Album.find('Carrie Underwood', 'Some Hearts')
    assert_equal('Carrie Underwood', album.artist)
    assert_equal('Some Hearts', album.name)
  end
  
  test "should be able to find an ablum and load the album's info" do
    album = Scrobbler::Album.find('Carrie Underwood', 'Some Hearts', :include_info => true)
    assert_equal('Carrie Underwood', album.artist)
    assert_equal('Some Hearts', album.name)
    assert_equal('18589', album.reach)
    assert_equal('http://www.last.fm/music/Carrie+Underwood/Some+Hearts', album.url)
    assert_equal(Time.mktime(2005, 11, 15, 00, 00, 00), album.release_date)
  end
  
  test "should be able to include the album's info on initialize" do
    album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts', :include_info => true)
    assert_equal('Carrie Underwood', album.artist)
    assert_equal('Some Hearts', album.name)
    assert_equal('18589', album.reach)
    assert_equal('http://www.last.fm/music/Carrie+Underwood/Some+Hearts', album.url)
    assert_equal(Time.mktime(2005, 11, 15, 00, 00, 00), album.release_date)
  end
  
  test 'should load info when trying to access tracks if info has not been loaded' do
    assert_equal(14, @album.tracks.size)
    assert_equal('Wasted', @album.tracks.first.name)
    assert_equal('http://www.last.fm/music/Carrie+Underwood/_/Wasted', @album.tracks.first.url)
    assert_equal('6738', @album.tracks.first.reach)
  end
  
  test 'should have an image method that accepts a type' do
    @album.load_info
    assert_equal('http://images.amazon.com/images/P/B000BGR18W.01.MZZZZZZZ.jpg', @album.image(:small))
    assert_equal('http://images.amazon.com/images/P/B000BGR18W.01.MZZZZZZZ.jpg', @album.image(:medium))
    assert_equal('http://images.amazon.com/images/P/B000BGR18W.01.MZZZZZZZ.jpg', @album.image(:large))
  end
  
  test "should raise an argument error when attempting to get an image that doesn't exist" do
    @album.load_info
    assert_raises(ArgumentError) { @album.image(:fake) }
  end
  
  test 'should load info when trying to access an image if the info has not been loaded' do
    assert_equal('http://images.amazon.com/images/P/B000BGR18W.01.MZZZZZZZ.jpg', @album.image(:small))
  end
end