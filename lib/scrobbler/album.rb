# Getting information about an album such as release date and the tracks on it is very easy.
# 
#   album = Scrobbler::Album.new('Carrie Underwood', 'Some Hearts', :include_info => true)
# 
#   puts "Album: #{album.name}"
#   puts "Artist: #{album.artist}"
#   puts "Reach: #{album.reach}"
#   puts "URL: #{album.url}"
#   puts "Release Date: #{album.release_date.strftime('%m/%d/%Y')}"
# 
#   puts
#   puts
# 
#   puts "Tracks"
#   longest_track_name = album.tracks.collect(&:name).sort { |x, y| y.length <=> x.length }.first.length
#   puts "=" * longest_track_name
#   album.tracks.each { |t| puts t.name }
#
# Would output:
#
#   Album: Some Hearts
#   Artist: Carrie Underwood
#   Reach: 18729
#   URL: http://www.last.fm/music/Carrie+Underwood/Some+Hearts
#   Release Date: 11/15/2005
# 
# 
#   Tracks
#   ===============================
#   Wasted
#   Don't Forget to Remember Me
#   Some Hearts
#   Jesus, Take the Wheel
#   The Night Before (Life Goes On)
#   Lessons Learned
#   Before He Cheats
#   Starts With Goodbye
#   I Just Can't Live a Lie
#   We're Young and Beautiful
#   That's Where It Is
#   Whenever You Remember
#   I Ain't in Checotah Anymore
#   Inside Your Heaven
module Scrobbler
  class Album < Base
    attr_accessor :artist, :artist_mbid, :name, :mbid, :playcount, :rank, :url, :reach, :release_date
    attr_accessor :image_large, :image_medium, :image_small
    attr_writer :tracks
    
    # needed on top albums for tag
    attr_accessor :count, :streamable
    
    # needed for weekly album charts
    attr_accessor :chartposition
    
    class << self
      def find(artist, name, o={})
        new(artist, name, o)
      end
      
      def new_from_xml(xml, doc=nil)
        name             = (xml).at(:name).inner_html                   if (xml).at(:name)
        name             = xml['name']                                  if name.nil? && xml['name']
        artist           = (xml).at(:artist)['name']                    if (xml).at(:artist) && (xml).at(:artist)['name']
        artist           = (xml).at(:artist).inner_html                 if artist.nil? && (xml).at(:artist)
        artist           = doc.root['artist']                           if artist.nil? && doc.root['artist']
        a                = Album.new(artist, name)
        a.artist_mbid    = (xml).at(:artist)['mbid']                    if (xml).at(:artist) && (xml).at(:artist)['mbid']
        a.artist_mbid    = (xml).at(:artist).at(:mbid).inner_html       if a.artist_mbid.nil? && (xml).at(:artist) && (xml).at(:artist).at(:mbid)
        a.mbid           = (xml).at(:mbid).inner_html                   if (xml).at(:mbid)
        a.playcount      = (xml).at(:playcount).inner_html              if (xml).at(:playcount)
        a.chartposition = (xml).at(:chartposition).inner_html          if (xml).at(:chartposition)
        a.rank           = (xml).at(:rank).inner_html                   if (xml).at(:rank)
        a.url            = (xml/:url).last.inner_html                   if (xml/:url).size > 1
        a.url            = (xml).at(:url).inner_html                    if a.url.nil? && (xml).at(:url)
        a.reach          = (xml).at(:reach).inner_html                  if (xml).at(:reach)
        a.image_large    = (xml).at(:image).at(:large).inner_html       if (xml).at(:image) && (xml).at(:image).at(:large)
        a.image_medium   = (xml).at(:image).at(:medium).inner_html      if (xml).at(:image) && (xml).at(:image).at(:medium)
        a.image_small    = (xml).at(:image).at(:small).inner_html       if (xml).at(:image) && (xml).at(:image).at(:small)
        
        # coverart element used on top albums for tag
        a.image_large    = (xml).at(:coverart).at(:large).inner_html    if a.image_large.nil? && (xml).at(:coverart) && (xml).at(:coverart).at(:large)
        a.image_medium   = (xml).at(:coverart).at(:medium).inner_html   if a.image_medium.nil? && (xml).at(:coverart) && (xml).at(:coverart).at(:medium)
        a.image_small    = (xml).at(:coverart).at(:small).inner_html    if a.image_small.nil? && (xml).at(:coverart) && (xml).at(:coverart).at(:small)
        
        # needed on top albums for tag
        a.count          = xml['count'] if xml['count']
        a.streamable     = xml['streamable'] if xml['streamable']
        a
      end
    end
    
    def initialize(artist, name, o={})
      raise ArgumentError, "Artist is required" if artist.blank?
      raise ArgumentError, "Name is required" if name.blank?
      @artist = artist
      @name   = name
      options = {:include_info => false}.merge(o)
      load_info() if options[:include_info]
    end
    
    def api_path
      "/#{API_VERSION}/album/#{CGI::escape(artist)}/#{CGI::escape(name)}"
    end
    
    def load_info
      doc           = self.class.fetch_and_parse("#{api_path}/info.xml")
      @reach        = (doc).at(:reach).inner_html
      @url          = (doc).at(:url).inner_html
      @release_date = Time.parse((doc).at(:releasedate).inner_html.strip)
      @image_large  = (doc).at(:coverart).at(:large).inner_html
      @image_medium = (doc).at(:coverart).at(:medium).inner_html
      @image_small  = (doc).at(:coverart).at(:small).inner_html
      @mbid         = (doc).at(:mbid).inner_html
      @tracks       = (doc/:track).inject([]) do |tracks, track|
        t             = Track.new(artist, track['title'])
        t.artist_mbid = artist_mbid
        t.album       = name
        t.album_mbid  = mbid
        t.url         = (track).at(:url).inner_html
        t.reach       = (track).at(:reach).inner_html
        tracks << t
        tracks
      end
    end
    
    def tracks
      load_info if @tracks.nil?
      @tracks
    end
    
    def image(which=:small)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large'].include?(which)      
      img_url = instance_variable_get("@image_#{which}")
      if img_url.nil?
        load_info
        img_url = instance_variable_get("@image_#{which}")
      end
      img_url
    end
  end
end