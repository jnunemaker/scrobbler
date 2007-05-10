require 'rubygems'
require 'scrobbler'

tag = Scrobbler::Tag.new('country')

puts 'Top Albums'
tag.top_albums.each { |a| puts "(#{a.count}) #{a.name} by #{a.artist}" }

puts

puts 'Top Tracks'
tag.top_tracks.each { |t| puts "(#{t.count}) #{t.name} by #{t.artist}" }