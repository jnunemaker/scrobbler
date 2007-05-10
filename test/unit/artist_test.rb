require File.dirname(__FILE__) + '/../test_helper.rb'

class TestArtist < Test::Unit::TestCase

  def setup
    @artist = Scrobbler::Artist.new('Metallica')
  end
  
  test 'should require name' do
    assert_raises(ArgumentError) { Scrobbler::Artist.new('') }
  end
  
  test "should know it's name" do
    assert_equal('Metallica', @artist.name)
  end
  
  test 'should have the correct api_path' do
    assert_equal('/1.0/artist/Metallica', @artist.api_path)
  end
  
  test 'should escape api path' do
    assert_equal('/1.0/artist/Carrie+Underwood', Scrobbler::Artist.new('Carrie Underwood').api_path)
  end
  
  test 'should have the correct ical path to current events' do
    assert_equal('http://ws.audioscrobbler.com/1.0/artist/Metallica/events.ics', @artist.current_events(:ical))
  end

  test 'should have the correct rss path to current events' do
    assert_equal('http://ws.audioscrobbler.com/1.0/artist/Metallica/events.rss', @artist.current_events(:rss))
  end
  
  test 'should be able to find similar artists' do
    assert_equal(['Iron Maiden', 'System of a Down', "Guns N' Roses", 'Rammstein'], @artist.similar.collect(&:name))
    first = @artist.similar.first
    assert_equal('Iron Maiden', first.name)
    assert_equal('ca891d65-d9b0-4258-89f7-e6ba29d83767', first.mbid)
    assert_equal('100', first.match)
    assert_equal('http://www.last.fm/music/Iron+Maiden', first.url)
    assert_equal('http://static3.last.fm/storable/image/177412/small.jpg', first.thumbnail)
    assert_equal('http://panther1.last.fm/proposedimages/sidebar/6/1000107/528560.jpg', first.image)
    assert_equal('yes', first.streamable)
  end
  
  test 'should be able to find top fans' do
    assert_equal(%w{Kikoin Chrisis92 delekt0r}, @artist.top_fans.collect(&:username))
    first = @artist.top_fans.first
    assert_equal('Kikoin', first.username)
    assert_equal('http://www.last.fm/user/Kikoin/', first.url)
    assert_equal('http://panther1.last.fm/avatar/621340085aed19b9ab77a0f8c575758a.gif', first.avatar)
    assert_equal('6081000', first.weight)
  end
  
  test 'should be able to find top tracks' do
    assert_equal(['Nothing Else Matters', 'Enter Sandman', 'Master of Puppets', 'One'], @artist.top_tracks.collect(&:name))
    first = @artist.top_tracks.first
    assert_equal('Nothing Else Matters', first.name)
    assert_equal('', first.mbid)
    assert_equal('http://www.last.fm/music/Metallica/_/Nothing+Else+Matters', first.url)
    assert_equal('59135', first.reach)
  end
  
  test 'should be able to find top albums' do
    assert_equal(['Master of Puppets', 'Metallica', 'Reload'], @artist.top_albums.collect(&:name))
    first = @artist.top_albums.first
    assert_equal('Master of Puppets', first.name)
    assert_equal('fed37cfc-2a6d-4569-9ac0-501a7c7598eb', first.mbid)
    assert_equal('65717', first.reach)
    assert_equal('http://www.last.fm/music/Metallica/Master+of+Puppets', first.url)
    assert_equal('http://cdn.last.fm/coverart/50x50/1411810.jpg', first.image(:small))
    assert_equal('http://cdn.last.fm/coverart/130x130/1411810.jpg', first.image(:medium))
    assert_equal('http://panther1.last.fm/coverart/130x130/1411810.jpg', first.image(:large))    
  end
  
  test 'should be able to find top tags' do
    assert_equal(['metal', 'thrash metal', 'heavy metal'], @artist.top_tags.collect(&:name))
    first = @artist.top_tags.first
    assert_equal('metal', first.name)
    assert_equal('100', first.count)
    assert_equal('http://www.last.fm/tag/metal', first.url)
  end
end