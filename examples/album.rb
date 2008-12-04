require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))

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