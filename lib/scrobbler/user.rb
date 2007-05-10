# Probably the most common use of this lib would be to get your most recent tracks or your top tracks. Below are some code samples.
#   user = Scrobbler::User.new('jnunemaker')
# 
#   puts "#{user.username}'s Recent Tracks"
#   puts "=" * (user.username.length + 16)
#   user.recent_tracks.each { |t| puts t.name }
# 
#   puts
#   puts
# 
#   puts "#{user.username}'s Top Tracks"
#   puts "=" * (user.username.length + 13)
#   user.top_tracks.each { |t| puts "(#{t.playcount}) #{t.name}" }
#   
# Which would output something like:
#
#   jnunemaker's Recent Tracks
#   ==========================
#   Everything You Want
#   You're a God
#   Bitter Sweet Symphony [Original Version]
#   Lord I Guess I'll Never Know
#   Country Song
#   Bitter Sweet Symphony (Radio Edit)
# 
# 
#   jnunemaker's Top Tracks
#   =======================
#   (62) Probably Wouldn't Be This Way
#   (55) Not Ready To Make Nice
#   (45) Easy Silence
#   (43) Song 2
#   (40) Everybody Knows
#   (39) Before He Cheats
#   (39) Something's Gotta Give
#   (38) Hips Don't Lie (featuring Wyclef Jean)
#   (37) Unwritten
#   (37) Move Along
#   (37) Dance, Dance
#   (36) We Belong Together
#   (36) Jesus, Take the Wheel
#   (36) Black Horse and the Cherry Tree (radio version)
#   (35) Photograph
#   (35) You're Beautiful
#   (35) Walk Away
#   (34) Stickwitu
module Scrobbler  
  class User < Base
    # attributes needed to initialize
    attr_reader :username
    
    # profile attributes
    attr_accessor :id, :cluster, :url, :realname, :mbox_sha1sum, :registered
    attr_accessor :registered_unixtime, :age, :gender, :country, :playcount, :avatar
    
    # neighbor attributes
    attr_accessor :match
    
    # track fans attributes
    attr_accessor :weight
    
    class << self
      def new_from_xml(xml, doc=nil)
        u        = User.new((xml)['username'])
        u.url    = (xml).at(:url).inner_html    if (xml).at(:url)
        u.avatar = (xml).at(:image).inner_html  if (xml).at(:image)
        u.weight = (xml).at(:weight).inner_html if (xml).at(:weight)
        u.match  = (xml).at(:match).inner_html  if (xml).at(:match)
        u
      end
      
      def find(*args)
        options = {:include_profile => false}
        options.merge!(args.pop) if args.last.is_a?(Hash)
        users = args.flatten.inject([]) { |users, u| users << User.new(u, options); users }
        users.length == 1 ? users.pop : users
      end
    end
    
    def initialize(username, o={})
      options = {:include_profile => false}.merge(o)
      raise ArgumentError if username.blank?
      @username = username
      load_profile() if options[:include_profile]
    end
    
    def api_path
      "/#{API_VERSION}/user/#{CGI::escape(username)}"
    end
    
    def current_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}#{api_path}/events.#{format}"
    end
    
    def friends_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}#{api_path}/friendevents.#{format}"
    end
    
    def recommended_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}#{api_path}/eventsysrecs.#{format}"
    end
    
    def load_profile
      doc                  = self.class.fetch_and_parse("#{api_path}/profile.xml")
      @id                  = (doc).at(:profile)['id']
      @cluster             = (doc).at(:profile)['cluster']
      @url                 = (doc).at(:url).inner_html
      @realname            = (doc).at(:realname).inner_html
      @mbox_sha1sum        = (doc).at(:mbox_sha1sum).inner_html
      @registered          = (doc).at(:registered).inner_html
      @registered_unixtime = (doc).at(:registered)['unixtime']
      @age                 = (doc).at(:age).inner_html
      @gender              = (doc).at(:gender).inner_html
      @country             = (doc).at(:country).inner_html
      @playcount           = (doc).at(:playcount).inner_html
      @avatar              = (doc).at(:avatar).inner_html
    end
    
    def top_artists(force=false)
      get_instance(:topartists, :top_artists, :artist, force)
    end
    
    def top_albums(force=false)
      get_instance(:topalbums, :top_albums, :album, force)
    end
    
    def top_tracks(force=false)
      get_instance(:toptracks, :top_tracks, :track, force)
    end
    
    def top_tags(force=false)
      get_instance(:toptags, :top_tags, :tag, force)
    end
    
    def friends(force=false)
      get_instance(:friends, :friends, :user, force)
    end
    
    def neighbours(force=false)
      get_instance(:neighbours, :neighbours, :user, force)
    end
    
    def recent_tracks(force=false)
      get_instance(:recenttracks, :recent_tracks, :track, force)
    end
    
    def recent_banned_tracks(force=false)
      get_instance(:recentbannedtracks, :recent_banned_tracks, :track, force)
    end
    
    def recent_loved_tracks(force=false)
      get_instance(:recentlovedtracks, :recent_loved_tracks, :track, force)
    end
    
    def recommendations(force=false)
      get_instance(:systemrecs, :recommendations, :artist, force)
    end
    
    def charts(force=false)
      get_instance(:weeklychartlist, :charts, :chart, force)
    end
    
    def weekly_artist_chart(from=nil, to=nil)
      qs  = create_query_string_from_timestamps(from, to)
      doc = self.class.fetch_and_parse("#{api_path}/weeklyartistchart.xml#{qs}")
      (doc/:artist).inject([]) { |elements, el| elements << Artist.new_from_xml(el); elements }
    end
    
    def weekly_album_chart(from=nil, to=nil)
      qs  = create_query_string_from_timestamps(from, to)
      doc = self.class.fetch_and_parse("#{api_path}/weeklyalbumchart.xml#{qs}")
      (doc/:album).inject([]) { |elements, el| elements << Album.new_from_xml(el); elements }
    end
    
    def weekly_track_chart(from=nil, to=nil)
      qs  = create_query_string_from_timestamps(from, to)
      doc = self.class.fetch_and_parse("#{api_path}/weeklytrackchart.xml#{qs}")
      (doc/:track).inject([]) { |elements, el| elements << Track.new_from_xml(el); elements }
    end
    
    private
      def create_query_string_from_timestamps(from, to)
        (from && to) ? "?from=#{from.to_i}&to=#{to.to_i}" : ''
      end
  end
end