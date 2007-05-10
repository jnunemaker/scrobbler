require 'rubygems'
require 'scrobbler'

track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
puts 'Fans'
puts "=" * 4
track.fans.each { |u| puts "(#{u.weight}) #{u.username}" }