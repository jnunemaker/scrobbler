require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'scrobbler'))

auth = Scrobbler::SimpleAuth.new(:user => 'chunky', :password => 'bacon')
auth.handshake!

puts "Auth Status: #{auth.status}"
puts "Session ID: #{auth.session_id}"
puts "Now Playing URL: #{auth.now_playing_url}"
puts "Submission URL: #{auth.submission_url}"

scrobble = Scrobbler::Scrobble.new(:session_id => auth.session_id,
                                   :submission_url => auth.submission_url,
                                   :artist => 'Coldplay',
                                   :track => 'Viva La Vida',
                                   :album => 'Viva La Vida',
                                   :time => Time.new,
                                   :length => 244,
                                   :track_number => 7)
scrobble.submit!
puts "Scrobbler Submission Status: #{scrobble.status}"

playing = Scrobbler::Playing.new(:session_id => auth.session_id,
                                 :now_playing_url => auth.now_playing_url,
                                 :artist => 'Anberlin',
                                 :track => 'A Day Late',
                                 :album => 'Never Take Friendship Personal',
                                 :length => 214,
                                 :track_number => 5)
                                 
playing.submit!         
puts "Playing Submission Status: #{playing.status}"      