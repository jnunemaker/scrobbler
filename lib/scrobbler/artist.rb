# Below are examples of how to find an artists top tracks and similar artists.
# 
#   artist = Scrobbler::Artist.new('Carrie Underwood')
# 
#   puts 'Top Tracks'
#   puts "=" * 10
#   artist.top_tracks.each { |t| puts "(#{t.reach}) #{t.name}" }
# 
#   puts
# 
#   puts 'Similar Artists'
#   puts "=" * 15
#   artist.similar.each { |a| puts "(#{a.match}%) #{a.name}" }
# 
# Would output something similar to:
# 
#   Top Tracks
#   ==========
#   (8797) Before He Cheats
#   (3574) Don't Forget to Remember Me
#   (3569) Wasted
#   (3246) Some Hearts
#   (3142) Jesus, Take the Wheel
#   (2600) Starts With Goodbye
#   (2511) Jesus Take The Wheel
#   (2423) Inside Your Heaven
#   (2328) Lessons Learned
#   (2040) I Just Can't Live a Lie
#   (1899) Whenever You Remember
#   (1882) We're Young and Beautiful
#   (1854) That's Where It Is
#   (1786) I Ain't in Checotah Anymore
#   (1596) The Night Before (Life Goes On)
#   
#   Similar Artists
#   ===============
#   (100%) Rascal Flatts
#   (84.985%) Keith Urban
#   (84.007%) Kellie Pickler
#   (82.694%) Katharine McPhee
#   (81.213%) Martina McBride
#   (79.397%) Faith Hill
#   (77.121%) Tim McGraw
#   (75.191%) Jessica Simpson
#   (75.182%) Sara Evans
#   (75.144%) The Wreckers
#   (73.034%) Kenny Chesney
#   (71.765%) Dixie Chicks
#   (71.084%) Kelly Clarkson
#   (69.535%) Miranda Lambert
#   (66.952%) LeAnn Rimes
#   (66.398%) Mandy Moore
#   (65.817%) Bo Bice
#   (65.279%) Diana DeGarmo
#   (65.115%) Gretchen Wilson
#   (62.982%) Clay Aiken
#   (62.436%) Ashlee Simpson
#   (62.160%) Christina Aguilera
module Scrobbler
  class Artist < Base
    attr_accessor :name, :mbid, :playcount, :rank, :url, :thumbnail, :image, :reach, :count, :streamable
    attr_accessor :chartposition
    
    # used for similar artists
    attr_accessor :match
    
    class << self
      def new_from_xml(xml, doc=nil)
        name             = (xml).at(:name).inner_html           if (xml).at(:name)
        # occasionally name can be found in root of artist element (<artist name="">) rather than as an element (<name>)
        name             = xml['name']                          if name.nil? && xml['name']
        a                = Artist.new(name)
        a.mbid           = (xml).at(:mbid).inner_html           if (xml).at(:mbid)
        a.playcount      = (xml).at(:playcount).inner_html      if (xml).at(:playcount)
        a.rank           = (xml).at(:rank).inner_html           if (xml).at(:rank)
        a.url            = (xml).at(:url).inner_html            if (xml).at(:url)
        a.thumbnail      = (xml).at(:thumbnail).inner_html      if (xml).at(:thumbnail)
        a.thumbnail      = (xml).at(:image_small).inner_html    if a.thumbnail.nil? && (xml).at(:image_small)
        a.image          = (xml).at(:image).inner_html          if (xml).at(:image)
        a.reach          = (xml).at(:reach).inner_html          if (xml).at(:reach)
        a.match          = (xml).at(:match).inner_html          if (xml).at(:match)
        a.chartposition = (xml).at(:chartposition).inner_html  if (xml).at(:chartposition)

        # in top artists for tag
        a.count          = xml['count']                         if xml['count']
        a.streamable     = xml['streamable']                    if xml['streamable']
        a.streamable     = (xml).at(:streamable).inner_html == '1' ? 'yes' : 'no' if a.streamable.nil? && (xml).at(:streamable)
        a
      end
    end
    
    def initialize(name)
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
    end
    
    def api_path
      "/#{API_VERSION}/artist/#{CGI::escape(name)}"
    end
    
    def current_events(format=:ics)
      format = :ics if format.to_s == 'ical'
      raise ArgumentError unless ['ics', 'rss'].include?(format.to_s)
      "#{API_URL.chop}#{api_path}/events.#{format}"
    end
    
    def similar(force=false)
      get_instance(:similar, :similar, :artist, force)
    end
    
    def top_fans(force=false)
      get_instance(:fans, :top_fans, :user, force)
    end
    
    def top_tracks(force=false)
      get_instance(:toptracks, :top_tracks, :track, force)
    end
    
    def top_albums(force=false)
      get_instance(:topalbums, :top_albums, :album, force)
    end
    
    def top_tags(force=false)
      get_instance(:toptags, :top_tags, :tag, force)
    end
  end
end