require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))
require 'pp'

track = Scrobbler::Track.new('Carrie Underwood', 'Before He Cheats')
puts 'Fans'
puts "=" * 4
track.fans.each { |u| puts "(#{u.weight}) #{u.username}" }

track = Scrobbler::Track.new('U2 & Green Day', 'The Saints Are Coming')
pp track.tags