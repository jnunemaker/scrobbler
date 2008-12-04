require File.dirname(__FILE__) + '/../../lib/scrobbler/rest'
require 'digest/md5'

module Scrobbler
  module REST
  	class Connection
  	  # reads xml fixture file instead of hitting up the internets
  	  def request(resource, method = "get", args = nil)
  	    @now_playing_url = 'http://62.216.251.203:80/nowplaying'
  	    @submission_url = 'http://62.216.251.205:80/protocol_1.2'
  	    @session_id = '17E61E13454CDD8B68E8D7DEEEDF6170'
  	    
  	    if @base_url == Scrobbler::API_URL
    	    pieces = resource.split('/')
    	    pieces.shift
    	    pieces.shift
    	    folder = pieces.shift
    	    file   = pieces.last[0, pieces.last.index('.xml')]
    	    base_pieces = pieces.last.split('?')
  	    
    	    file = if base_pieces.size > 1
    	      # if query string params are in resource they are underscore separated for filenames
    	      base_pieces.last.split('&').inject("#{file}_") { |str, pair| str << pair.split('=').join('_') + '_'; str }.chop!
  	      else
  	        file
          end
  	    
    	    File.read(File.dirname(__FILE__) + "/../fixtures/xml/#{folder}/#{file}.xml")
  	    elsif @base_url == Scrobbler::AUTH_URL
          if args[:hs] == "true" && args[:p] == Scrobbler::AUTH_VER.to_s && args[:c] == 'rbs' &&
             args[:v] == Scrobbler::Version.to_s && args[:u] == 'chunky' && !args[:t].blank? &&
             args[:a] == Digest::MD5.hexdigest('7813258ef8c6b632dde8cc80f6bda62f' + args[:t])
            
            "OK\n#{@session_id}\n#{@now_playing_url}\n#{@submission_url}"
          end
        elsif @base_url == @now_playing_url
          if args[:s] == @session_id && ![args[:a], args[:t], args[:b], args[:n]].any?(&:blank?)
             'OK'
          end           
        elsif @base_url == @submission_url
          if args[:s] == @session_id && 
             ![args['a[0]'], args['t[0]'], args['i[0]'], args['o[0]'], args['l[0]'], args['b[0]']].any?(&:blank?)
            'OK'
          end
	      end
	      
	    end
	  end
  end
end