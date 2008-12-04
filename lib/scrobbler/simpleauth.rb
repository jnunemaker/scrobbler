require 'digest/md5'

# exception definitions
class BadAuthError < StandardError; end
class BannedError < StandardError; end
class BadTimeError < StandardError; end
module Scrobbler
  AUTH_URL = 'http://post.audioscrobbler.com'
  AUTH_VER = '1.2.1'
  
  class SimpleAuth
    # you should read last.fm/api/submissions#handshake

    attr_accessor :user, :password, :client_id, :client_ver
    attr_reader :status, :session_id, :now_playing_url, :submission_url

    def initialize(args = {})
      @user = args[:user] # last.fm username
      @password = args[:password] # last.fm password
      @client_id = 'rbs' # Client ID assigned by last.fm; Don't change this!
      @client_ver = Scrobbler::Version

      raise ArgumentError, 'Missing required argument' if @user.blank? || @password.blank?

      @connection = REST::Connection.new(AUTH_URL)
    end

    def handshake!
      password_hash = Digest::MD5.hexdigest(@password)
      timestamp = Time.now.to_i.to_s
      token = Digest::MD5.hexdigest(password_hash + timestamp)

      query = { :hs => 'true',
                :p => AUTH_VER,
                :c => @client_id,
                :v => @client_ver,
                :u => @user,
                :t => timestamp,
                :a => token }
      result = @connection.get('/', query)

      @status = result.split(/\n/)[0]
      case @status
      when /OK/
        @session_id, @now_playing_url, @submission_url = result.split(/\n/)[1,3]
      when /BANNED/
        raise BannedError # something is wrong with the gem, check for an update
      when /BADAUTH/
        raise BadAuthError # invalid user/password
      when /FAILED/
        raise RequestFailedError, @status
      when /BADTIME/
        raise BadTimeError # system time is way off
      else
        raise RequestFailedError
      end  
    end
  end
end