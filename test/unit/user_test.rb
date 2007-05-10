require File.dirname(__FILE__) + '/../test_helper.rb'

class TestUser < Test::Unit::TestCase

  def setup
    @user = Scrobbler::User.new('jnunemaker')
  end
  
  test 'should be able to find one user' do
    assert_equal(@user.username, Scrobbler::User.find('jnunemaker').username)
  end
  
  test 'should be able to find multiple users' do
    users = Scrobbler::User.find('jnunemaker', 'oaknd1', 'wharle')
    assert_equal(%w{jnunemaker oaknd1 wharle}, users.collect(&:username))
  end
  
  test 'should be able to find multiple users using an array' do
    users = Scrobbler::User.find(%w{jnunemaker oaknd1 wharle})
    assert_equal(%w{jnunemaker oaknd1 wharle}, users.collect(&:username))
  end
  
  test 'should be able to load profile while finding' do
    user = Scrobbler::User.find('jnunemaker', :include_profile => true)
    assert_equal(@user.username, user.username)
    assert_equal('3017870', user.id)
  end
  
  test 'should be able to load profile while finding multiple users' do
    users = Scrobbler::User.find('jnunemaker', 'oaknd1', 'wharle', :include_profile => true)
    assert_equal(3, users.size)
  end
  
  test 'should require a username' do
    assert_raise(ArgumentError) { Scrobbler::User.new('') }
  end
  
  test 'should have api path' do
    assert_equal('/1.0/user/jnunemaker', @user.api_path)
  end
  
  test 'should know the correct current events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.ics', @user.current_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.ics', @user.current_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/events.rss', @user.current_events(:rss))
  end
  
  test 'should know the correct friends events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.ics', @user.friends_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.ics', @user.friends_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/friendevents.rss', @user.friends_events(:rss))
  end
  
  test 'should know the correct recommended events addresses' do
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.ics', @user.recommended_events(:ical))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.ics', @user.recommended_events(:ics))
    assert_equal('http://ws.audioscrobbler.com/1.0/user/jnunemaker/eventsysrecs.rss', @user.recommended_events(:rss))
  end
  
  test 'should be able to include profile during initialization' do
    user = Scrobbler::User.new('jnunemaker', :include_profile => true)
    assert_equal('3017870', user.id)
    assert_equal('4', user.cluster)
    assert_equal('http://www.last.fm/user/jnunemaker/', user.url)
    assert_equal('John Nunemaker', user.realname)
    assert_equal('d5bbe280b7a41d4a87253361692ef105b983cf1a', user.mbox_sha1sum)
    assert_equal('Dec 8, 2005', user.registered)
    assert_equal('1134050307', user.registered_unixtime)
    assert_equal('25', user.age)
    assert_equal('m', user.gender)
    assert_equal('United States', user.country)
    assert_equal('13267', user.playcount)
    assert_equal('http://panther1.last.fm/avatar/5cb420de0855dadf6bcb1090d8ff02bb.jpg', user.avatar)
  end
  
  test 'should be able to load users profile' do
    @user.load_profile
    assert_equal('3017870', @user.id)
    assert_equal('4', @user.cluster)
    assert_equal('http://www.last.fm/user/jnunemaker/', @user.url)
    assert_equal('John Nunemaker', @user.realname)
    assert_equal('d5bbe280b7a41d4a87253361692ef105b983cf1a', @user.mbox_sha1sum)
    assert_equal('Dec 8, 2005', @user.registered)
    assert_equal('1134050307', @user.registered_unixtime)
    assert_equal('25', @user.age)
    assert_equal('m', @user.gender)
    assert_equal('United States', @user.country)
    assert_equal('13267', @user.playcount)
    assert_equal('http://panther1.last.fm/avatar/5cb420de0855dadf6bcb1090d8ff02bb.jpg', @user.avatar)
  end
  
  test "should be able to get a user's top artists" do
    assert_equal(3, @user.top_artists.size)
    first = @user.top_artists.first
    assert_equal('Dixie Chicks', first.name)
    assert_equal('3248ed2d-bada-41b5-a7b6-ac88faa1f1ac', first.mbid)
    assert_equal('592', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/Dixie+Chicks', first.url)
    assert_equal('http://static3.last.fm/storable/image/182497/small.jpg', first.thumbnail)
    assert_equal('http://panther1.last.fm/proposedimages/sidebar/6/4037/512759.jpg', first.image)
  end
  
  test 'should be able to get top albums' do
    assert_equal(3, @user.top_albums.size)
    first = @user.top_albums.first
    assert_equal('LeAnn Rimes', first.artist)
    assert_equal('9092d8e1-9b38-4372-a96d-000b8561a8bc', first.artist_mbid)
    assert_equal('This Woman', first.name)
    assert_equal('080a4038-5156-460a-8dd5-daaa7d16b6a6', first.mbid)
    assert_equal('297', first.playcount)
    assert_equal('1', first.rank)    
    assert_equal('http://www.last.fm/music/LeAnn+Rimes/This+Woman', first.url)
    assert_equal('http://images.amazon.com/images/P/B00067BD8K.01._SCMZZZZZZZ_.jpg', first.image(:small))
    assert_equal('http://images.amazon.com/images/P/B00067BD8K.01._SCMZZZZZZZ_.jpg', first.image(:medium))
    assert_equal('http://images.amazon.com/images/P/B00067BD8K.01._SCMZZZZZZZ_.jpg', first.image(:large))
  end
  
  test 'should be able to get top tracks' do
    assert_equal(3, @user.top_tracks.size)
    first = @user.top_tracks.first
    assert_equal("Probably Wouldn't Be This Way", first.name)
    assert_equal('LeAnn Rimes', first.artist)
    assert_equal('9092d8e1-9b38-4372-a96d-000b8561a8bc', first.artist_mbid)
    assert_equal("", first.mbid)
    assert_equal('61', first.playcount)
    assert_equal('1', first.rank)
    assert_equal('http://www.last.fm/music/LeAnn+Rimes/_/Probably+Wouldn%27t+Be+This+Way', first.url)
  end
  
  test 'should be able to get top tags' do
    assert_equal(3, @user.top_tags.size)
    first = @user.top_tags.first
    assert_equal("country", first.name)
    assert_equal("6", first.count)
    assert_equal("http://www.last.fm/tag/country", first.url)
  end
  
  # not implemented
  test 'should be able to get top tags for artist' do
  end
  # not implemented
  test 'should be able to get top tags for album' do
  end
  # not implemented
  test 'should be able to get top tags for track' do
  end
  
  test 'should have friends' do
    assert_equal(3, @user.friends.size)
    first = @user.friends.first
    assert_equal('oaknd1', first.username)
    assert_equal('http://www.last.fm/user/oaknd1/', first.url)
    assert_equal('http://panther1.last.fm/avatar/1894043b3e8995c51f7bb5e3210ef97a.jpg', first.avatar)
  end
  
  test 'should have neighbours' do
    assert_equal(3, @user.neighbours.size)
    first = @user.neighbours.first
    assert_equal('xBluejeanbabyx', first.username)
    assert_equal('http://www.last.fm/user/xBluejeanbabyx/', first.url)
    assert_equal('http://panther1.last.fm/avatar/d4de2144dc9b651b02d5d633124f0205.jpg', first.avatar)
  end
  
  test 'should have recent tracks' do
    assert_equal(3, @user.recent_tracks.size)
    first = @user.recent_tracks.first
    assert_equal('Recovering the Satellites', first.name)
    assert_equal('Counting Crows', first.artist)
    assert_equal('a0327dc2-dc76-44d5-aec6-47cd2dff1469', first.artist_mbid)
    assert_equal('', first.mbid)
    assert_equal('328bc43b-a81a-4dc0-844f-1a27880e5fb2', first.album_mbid)
    assert_equal('Recovering the Satellites', first.album)
    assert_equal('http://www.last.fm/music/Counting+Crows/_/Recovering+the+Satellites', first.url)
    assert_equal(Time.mktime(2007, 5, 4, 21, 1, 00), first.date)
    assert_equal('1178312462', first.date_uts)
  end
  
  test 'should have recent banned tracks' do
    assert_equal(3, @user.recent_banned_tracks.size)
    first = @user.recent_banned_tracks.first
    assert_equal('Dress Rehearsal Rag', first.name)
    assert_equal('Leonard Cohen', first.artist)
    assert_equal('65314b12-0e08-43fa-ba33-baaa7b874c15', first.artist_mbid)
    assert_equal('', first.mbid)
    assert_equal('http://www.last.fm/music/Leonard+Cohen/_/Dress+Rehearsal+Rag', first.url)
    assert_equal(Time.mktime(2006, 9, 27, 14, 19, 00), first.date)
    assert_equal('1159366744', first.date_uts)
  end
  
  test 'should have recent loved tracks' do
    assert_equal(3, @user.recent_loved_tracks.size)
    first = @user.recent_loved_tracks.first
    assert_equal('Am I Missing', first.name)
    assert_equal('Dashboard Confessional', first.artist)
    assert_equal('50549203-9602-451c-b49f-ff031ba8635c', first.artist_mbid)
    assert_equal('', first.mbid)
    assert_equal('http://www.last.fm/music/Dashboard+Confessional/_/Am+I+Missing', first.url)
    assert_equal(Time.mktime(2006, 9, 26, 17, 43, 00), first.date)
    assert_equal('1159292606', first.date_uts)
  end
  
  test 'should have recommendations' do
    assert_equal(3, @user.recommendations.size)
    first = @user.recommendations.first
    assert_equal('Kaiser Chiefs', first.name)
    assert_equal('90218af4-4d58-4821-8d41-2ee295ebbe21', first.mbid)
    assert_equal('http://www.last.fm/music/Kaiser+Chiefs', first.url)
  end
  
  test 'should have charts' do
    assert_equal(71, @user.charts.size)
    first = @user.charts.first
    assert_equal(1134302403, first.from)
    assert_equal(1134907203, first.to)
  end
  
  test 'should have weekly artist chart' do
    chart = @user.weekly_artist_chart
    assert_equal(5, chart.size)
    first = chart.first
    assert_equal('Rascal Flatts', first.name)
    assert_equal('6e0ae159-8449-4262-bba5-18ec87fa529f', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('25', first.playcount)
    assert_equal('http://www.last.fm/music/Rascal+Flatts', first.url)
  end
  
  test 'should have weekly artist chart for past weeks' do
    chart = @user.weekly_artist_chart(1138536002, 1139140802)
    assert_equal(8, chart.size)
    first = chart.first
    assert_equal('Jenny Lewis with The Watson Twins', first.name)
    assert_equal('4b179fe2-dfa5-40b1-b6db-b56dbc3b5f09', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('48', first.playcount)
    assert_equal('http://www.last.fm/music/Jenny+Lewis+with+The+Watson+Twins', first.url)
  end
  
  test 'should have weekly album chart' do
    chart = @user.weekly_album_chart
    assert_equal(4, chart.size)
    first = chart.first
    assert_equal('Reba McEntire', first.artist)
    assert_equal('3ec17e85-9284-4f4c-8831-4e56c2354cdb', first.artist_mbid)
    assert_equal("Reba #1's", first.name)
    assert_equal('', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('13', first.playcount)
    assert_equal('http://www.last.fm/music/Reba+McEntire/Reba%2B%25231%2527s', first.url)
  end
  
  test 'should have weekly album chart for past weeks' do
    chart = @user.weekly_album_chart(1138536002, 1139140802)
    assert_equal(4, chart.size)
    first = chart.first
    assert_equal('Jewel', first.artist)
    assert_equal('abae8575-ec8a-4736-abc3-1ad5093a68aa', first.artist_mbid)
    assert_equal("0304", first.name)
    assert_equal('52b3f067-9d82-488c-9747-6d608d9b9486', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('13', first.playcount)
    assert_equal('http://www.last.fm/music/Jewel/0304', first.url)
  end
  
  test 'should have track album chart' do
    chart = @user.weekly_track_chart
    assert_equal(4, chart.size)
    first = chart.first
    assert_equal('Rebecca St. James', first.artist)
    assert_equal('302716e4-a702-4bbc-baac-591f8a8e20bc', first.artist_mbid)
    assert_equal('Omega', first.name)
    assert_equal('', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('2', first.playcount)
    assert_equal('http://www.last.fm/music/Rebecca+St.+James/_/Omega', first.url)
  end
  
  test 'should have weekly track chart for past weeks' do
    chart = @user.weekly_track_chart(1138536002, 1139140802)
    assert_equal(4, chart.size)
    first = chart.first
    assert_equal('Natasha Bedingfield', first.artist)
    assert_equal('8b477559-946e-4ef2-9fe1-446cff8fdd79', first.artist_mbid)
    assert_equal('Unwritten', first.name)
    assert_equal('', first.mbid)
    assert_equal('1', first.chartposition)
    assert_equal('8', first.playcount)
    assert_equal('http://www.last.fm/music/Natasha+Bedingfield/_/Unwritten', first.url)
  end
end