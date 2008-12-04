# exception definitions
class BadSessionError < StandardError; end
class RequestFailedError < StandardError; end

module Scrobbler
  class Scrobble
    # you need to read last.fm/api/submissions#subs first!

    attr_accessor :session_id, :submission_url, :artist, :track, :time,
                  :source, :length, :album, :track_number, :mb_track_id
    attr_reader :status

    def initialize(args = {})
      @session_id = args[:session_id] # from Scrobbler::SimpleAuth
      @submission_url = args[:submission_url] # from Scrobbler::SimpleAuth (can change)
      @artist = args[:artist] # track artist
      @track = args[:track] # track name
      @time = args[:time] # a Time object set to the time the track started playing
      @source = args[:source] || 'P' # track source, see last.fm/api/submissions#subs
      @length = args[:length].to_s || '' # track length in seconds
      @album = args[:album] || '' # track album name (optional)
      @track_number = args[:track_number] || '' # track number (optional)
      @mb_track_id = args[:mb_track_id] || '' # MusicBrainz track ID (optional)

      if [@session_id, @submission_url, @artist, @track].any?(&:blank?)
        raise ArgumentError, 'Missing required argument'
      elsif @time.class.to_s != 'Time'
        raise ArgumentError, ":time must be a Time object"
      elsif !['P','R','E','U'].include?(@source) # see last.fm/api/submissions#subs
        raise ArgumentError, "Invalid source"
      elsif @source == 'P' && @length.blank? # length is not optional if source is P
        raise ArgumentError, 'Length must be set'
      elsif !@length.blank? && @length.to_i <= 30 # see last.fm/api/submissions#subs
        raise ArgumentError, 'Length must be greater than 30 seconds'
      end

      @connection = REST::Connection.new(@submission_url)
    end

    def submit!
      query = { :s => @session_id,
                'a[0]' => @artist,
                't[0]' => @track,
                'i[0]' => @time.utc.to_i,
                'o[0]' => @source,
                'r[0]' => '',
                'l[0]' => @length,
                'b[0]' => @album,
                'n[0]' => @track_number,
                'm[0]' => @mb_track_id }
                
      @status = @connection.post('', query)

      case @status
      when /OK/

      when /BADSESSION/
        raise BadSessionError # rerun Scrobbler::SimpleAuth#handshake!
      when /FAILED/
        raise RequestFailedError, @status
      else
        raise RequestFailedError
      end
    end
  end
end