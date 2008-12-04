require File.dirname(__FILE__) + '/../test_helper.rb'

class TestPlaying < Test::Unit::TestCase
  
  def setup
    @session_id = '17E61E13454CDD8B68E8D7DEEEDF6170'
    @now_playing_url = 'http://62.216.251.203:80/nowplaying'
    @artist = 'Anberlin'
    @track = 'A Day Late'
    @album = 'Never Take Friendship Personal'
    
    @playing = Scrobbler::Playing.new(:session_id => @session_id, :now_playing_url => @now_playing_url,
                                      :artist => @artist, :track => @track, :album => @album, :length => 214,
                                      :track_number => 5)
  end
  
  test 'should require a session id' do
    assert_raises(ArgumentError) { Scrobbler::Playing.new(
                                      :now_playing_url => @now_playing_url, :artist => @artist, :track => @track,
                                      :album => @album, :length => 214, :track_number => 5) }
  end
  
  test 'should require a now playing url' do
    assert_raises(ArgumentError) { Scrobbler::Playing.new(
                                      :session_id => @session_id, :artist => @artist, :track => @track,
                                      :album => @album, :length => 214, :track_number => 5) }
  end
  
  test 'should require an artist' do
    assert_raises(ArgumentError) { Scrobbler::Playing.new(
                                      :session_id => @session_id, :now_playing_url => @now_playing_url,
                                      :track => @track, :album => @album, :length => 214, :track_number => 5) }
  end
  
  test 'should require a track' do
    assert_raises(ArgumentError) { Scrobbler::Playing.new(
                                      :session_id => @session_id, :now_playing_url => @now_playing_url,
                                      :artist => @artist, :album => @album, :length => 214, :track_number => 5) }
  end
  
  test 'should require a length greater than 30 seconds' do
    assert_raises(ArgumentError) { Scrobbler::Playing.new(
                                      :session_id => @session_id, :now_playing_url => @now_playing_url,
                                      :artist => @artist, :track => @track, :album => @album, :length => 29,
                                      :track_number => 5) }
  end
  
  test 'should submit successfully' do
    @playing.submit!
    assert_equal('OK', @playing.status)
  end
  
end