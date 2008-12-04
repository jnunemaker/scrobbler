require File.dirname(__FILE__) + '/../test_helper.rb'

class TestSimpleAuth < Test::Unit::TestCase
  
  def setup
    @auth = Scrobbler::SimpleAuth.new(:user => 'chunky', :password => 'bacon')
  end
  
  test 'should require a user' do
    assert_raises(ArgumentError) { Scrobbler::SimpleAuth.new(:password => 'bacon') }
  end
  
  test 'should require a password' do
    assert_raises(ArgumentError) { Scrobbler::SimpleAuth.new(:user => 'chunky') }
  end
  
  test 'should have the right client id' do
    assert_equal('rbs', @auth.client_id)
  end
  
  test 'should have the right version' do
    assert_equal(Scrobbler::Version, @auth.client_ver)
  end
  
  test 'should handshake successfully' do
    @auth.handshake!
    assert_equal('OK', @auth.status)
  end
  
  test 'should get a session id' do
    @auth.handshake!
    assert_equal('17E61E13454CDD8B68E8D7DEEEDF6170', @auth.session_id)
  end
  
  test 'should get a now playing url' do
    @auth.handshake!
    assert_equal('http://62.216.251.203:80/nowplaying', @auth.now_playing_url)
  end
  
  test 'should get a submission url' do
    @auth.handshake!
    assert_equal('http://62.216.251.205:80/protocol_1.2', @auth.submission_url)
  end
  
end