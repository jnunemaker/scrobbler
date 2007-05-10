require File.dirname(__FILE__) + '/../test_helper.rb'

class TestTrack < Test::Unit::TestCase
  def setup
    @track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
  end
  
  test 'should require the artist name' do
    assert_raises(ArgumentError) { Scrobbler::Track.new('', 'Before He Cheats') }
  end
  
  test 'should require the track name' do
    assert_raises(ArgumentError) { Scrobbler::Track.new('Carrie Underwood', '') }
  end
  
  test "should know the artist" do
    assert_equal('Carrie Underwood', @track.artist)
  end
  
  test 'should know the name' do
    assert_equal('Before He Cheats', @track.name)
  end
  
  test 'should have api path' do
    assert_equal('/1.0/track/Carrie+Underwood/Before+He+Cheats', @track.api_path)
  end
  
  test 'should have fans' do
    assert_equal(5, @track.fans.size)
    assert_equal('frozenice', @track.fans.first.username)
    assert_equal('http://www.last.fm/user/frozenice/', @track.fans.first.url)
    assert_equal('http://panther1.last.fm/avatar/54e8d2cafc363336e15fef0a48d30706.jpg', @track.fans.first.avatar)
    assert_equal('909', @track.fans.first.weight)
  end
  
  test 'should have top tags' do
    assert_equal(6, @track.tags.size)
    assert_equal('country', @track.tags.first.name)
    assert_equal('100', @track.tags.first.count)
    assert_equal('http://www.last.fm/tag/country', @track.tags.first.url)
  end
end