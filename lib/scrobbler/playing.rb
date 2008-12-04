module Scrobbler
  class Playing
    # you should read last.fm/api/submissions#np first!

    attr_accessor :session_id, :now_playing_url, :artist, :track,
                  :album, :length, :track_number, :mb_track_id
    attr_reader :status

    def initialize(args = {})
      @session_id = args[:session_id] # from Scrobbler::SimpleAuth
      @now_playing_url = args[:now_playing_url] # from Scrobbler::SimpleAuth (can change)
      @artist = args[:artist] # track artist
      @track = args[:track] # track name
      @album = args[:album] || '' # track album (optional)
      @length = args[:length] || '' # track length in seconds (optional)
      @track_number = args[:track_number] || '' # track number (optional)
      @mb_track_id = args[:mb_track_id] || '' # MusicBrainz track ID (optional)

      if [@session_id, @now_playing_url, @artist, @track].any?(&:blank?)
        raise ArgumentError, 'Missing required argument'
      elsif !@length.to_s.empty? && @length.to_i <= 30 # see last.fm/api
        raise ArgumentError, 'Length must be greater than 30 seconds'
      end 

      @connection = REST::Connection.new(@now_playing_url)
    end

    def submit!
      query = { :s => @session_id,
                :a => @artist,
                :t => @track,
                :b => @album,
                :l => @length,
                :n => @track_number,
                :m => @mb_track_id }

      @status = @connection.post('', query)

      case @status
      when /OK/

      when /BADSESSION/
        raise BadSessionError # rerun Scrobbler::SimpleAuth#handshake!
      else
        raise RequestFailedError
      end
    end
  end
end