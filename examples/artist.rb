require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))

artist = Scrobbler::Artist.new('Carrie Underwood')

puts 'Top Tracks'
puts "=" * 10
artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }

puts

puts 'Similar Artists'
puts "=" * 15
artist.similar.each { |a| puts "(#{a.match}%) #{a.name}" }