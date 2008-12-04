require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))

user = Scrobbler::User.new('jnunemaker')

puts "#{user.username}'s Recent Tracks"
puts "=" * (user.username.length + 16)
user.recent_tracks.each { |t| puts t.name }

puts
puts

puts "#{user.username}'s Top Tracks"
puts "=" * (user.username.length + 13)
user.top_tracks.each { |t| puts "(#{t.playcount}) #{t.name}" }