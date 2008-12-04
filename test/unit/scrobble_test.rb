require File.dirname(__FILE__) + '/../test_helper.rb'

class TestScrobble < Test::Unit::TestCase
  
  def setup
    @session_id = '17E61E13454CDD8B68E8D7DEEEDF6170'
    @submission_url = 'http://62.216.251.205:80/protocol_1.2'
    @artist = 'Coldplay'
    @name = 'Viva La Vida'
    
    @scrobble = Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7)
  end
  
  test 'should require a session id' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7) }
  end
  
  test 'should require a submission url' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7) }
  end
  
  test 'should require an artist' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :track => @name, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7) }
  end
  
  test 'should require a track' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7) }
  end
  
  test 'should require a Time object' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => 'chunky_bacon',
                                        :length => 244, :track_number => 7) }
  end
  
  test 'should require a valid source' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :length => 244, :track_number => 7, :source => 'Z') }
  end
  
  test 'should require a length if source is set to P' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :track_number => 7, :source => 'P') }
  end
  
  test 'should require a length greater than 30 if source is set to P' do
    assert_raises(ArgumentError) { Scrobbler::Scrobble.new(:session_id => @session_id, :submission_url => @submission_url,
                                        :artist => @artist, :track => @name, :album => @name, :time => Time.new,
                                        :length => 29, :track_number => 7, :source => 'P') }
  end
  
  test 'should submit successfully' do
    @scrobble.submit!
    assert_equal('OK', @scrobble.status)
  end
  
end