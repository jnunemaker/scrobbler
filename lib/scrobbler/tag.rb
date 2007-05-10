# Below is code samples for how to find the top albums and tracks for a tag.
# 
#   tag = Scrobbler::Tag.new('country')
# 
#   puts 'Top Albums'
#   tag.top_albums.each { |a| puts "(#{a.count}) #{a.name} by #{a.artist}" }
# 
#   puts
# 
#   puts 'Top Tracks'
#   tag.top_tracks.each { |t| puts "(#{t.count}) #{t.name} by #{t.artist}" }
#   
# Which would output something similar to:
# 
#   Top Albums
#   (29) American IV: The Man Comes Around by Johnny Cash
#   (14) Folks Pop In at the Waterhouse by Various Artists
#   (13) Hapless by Flowers From The Man Who Shot Your Cousin
#   (9) Taking The Long Way by Dixie Chicks
#   (8) Unchained by Johnny Cash
#   (8) American III: Solitary Man by Johnny Cash
#   (8) Wide Open Spaces by Dixie Chicks
#   (7) It's Now or Later by Tangled Star
#   (7) Greatest Hits by Hank Williams
#   (7) American Recordings by Johnny Cash
#   (6) Forgotten Landscape by theNoLifeKing
#   (6) At Folsom Prison by Johnny Cash
#   (6) Fox Confessor Brings the Flood by Neko Case
#   (6) Murder by Johnny Cash
#   (5) Gloom by theNoLifeKing
#   (5) Set This Circus Down by Tim McGraw
#   (5) Blacklisted by Neko Case
#   (5) Breathe by Faith Hill
#   (5) Unearthed (disc 4: My Mother's Hymn Book) by Johnny Cash
#   (4) Home by Dixie Chicks
# 
#   Top Tracks
#   (221) Hurt by Johnny Cash
#   (152) I Walk the Line by Johnny Cash
#   (147) Ring of Fire by Johnny Cash
#   (125) Folsom Prison Blues by Johnny Cash
#   (77) The Man Comes Around by Johnny Cash
#   (67) Personal Jesus by Johnny Cash
#   (65) Not Ready To Make Nice by Dixie Chicks
#   (63) Before He Cheats by Carrie Underwood
#   (62) Give My Love to Rose by Johnny Cash
#   (49) Jackson by Johnny Cash
#   (49) What Hurts The Most by Rascal Flatts
#   (48) Big River by Johnny Cash
#   (46) Man in Black by Johnny Cash
#   (46) Jolene by Dolly Parton
#   (46) Friends in Low Places by Garth Brooks
#   (46) One by Johnny Cash
#   (44) Cocaine Blues by Johnny Cash
#   (41) Get Rhythm by Johnny Cash
#   (41) I Still Miss Someone by Johnny Cash
#   (40) The Devil Went Down to Georgia by Charlie Daniels Band
module Scrobbler
  class Tag < Base
    attr_accessor :name, :count, :url
    
    class << self
      def new_from_xml(xml, doc=nil)
        name    = (xml).at(:name).inner_html
        t       = Tag.new(name)
        t.count = (xml).at(:count).inner_html
        t.url   = (xml).at(:url).inner_html
        t
      end
      
      def top_tags
        doc = fetch_and_parse("/#{API_VERSION}/tag/toptags.xml")
        @top_tags = (doc/:tag).inject([]) do |tags, tag|
          t       = Tag.new(tag['name'])
          t.count = tag['count']
          t.url   = tag['url']
          tags << t
          tags
        end
      end
    end
    
    def initialize(name)
      raise ArgumentError, "Name is required" if name.blank?
      @name = name
    end
    
    def api_path
      "/#{API_VERSION}/tag/#{CGI::escape(name)}"
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
  end
end