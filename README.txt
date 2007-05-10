=Scrobbler

Scrobbler is a wrapper for the audioscrobbler web services (http://www.audioscrobbler.net/data/webservices/). 

Below is just a sampling of how easy this lib is to use.

== Users

	user = Scrobbler::User.new('jnunemaker')

	puts "#{user.username}'s Recent Tracks"
	puts "=" * (user.username.length + 16)
	user.recent_tracks.each { |t| puts t.name }

	puts
	puts

	puts "#{user.username}'s Top Tracks"
	puts "=" * (user.username.length + 13)
	user.top_tracks.each { |t| puts "(#{t.playcount}) #{t.name}" }
	
== Albums
	
	album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts', :include_info => true)

	puts "Album: #{album.name}"
	puts "Artist: #{album.artist}"
	puts "Reach: #{album.reach}"
	puts "URL: #{album.url}"
	puts "Release Date: #{album.release_date.strftime('%m/%d/%Y')}"

	puts
	puts

	puts "Tracks"
	longest_track_name = album.tracks.collect(&:name).sort { |x, y| y.length <=> x.length }.first.length
	puts "=" * longest_track_name
	album.tracks.each { |t| puts t.name }
	
==Artists
	
	artist = Scrobbler::Artist.new('Carrie Underwood')

	puts 'Top Tracks'
	puts "=" * 10
	artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }

	puts

	puts 'Similar Artists'
	puts "=" * 15
	artist.similar.each { |a| puts "(#{a.match}%) #{a.name}" }
	
==Tags	
	
	tag = Scrobbler::Tag.new('country')

	puts 'Top Albums'
	tag.top_albums.each { |a| puts "(#{a.count}) #{a.name} by #{a.artist}" }

	puts

	puts 'Top Tracks'
	tag.top_tracks.each { |t| puts "(#{t.count}) #{t.name} by #{t.artist}" }
	
==Tracks
	
	track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
	puts 'Fans'
	puts "=" * 4
	track.fans.each { |u| puts "(#{u.weight}) #{u.username}" }