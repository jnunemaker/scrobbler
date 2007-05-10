%w{cgi rubygems hpricot active_support}.each { |x| require x }

require 'scrobbler/base'

require 'scrobbler/album'
require 'scrobbler/artist'
require 'scrobbler/chart'
require 'scrobbler/user'
require 'scrobbler/tag'
require 'scrobbler/track'

require 'scrobbler/rest'
require 'scrobbler/version'
