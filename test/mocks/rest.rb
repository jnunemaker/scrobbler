require File.dirname(__FILE__) + '/../../lib/scrobbler/rest'

module Scrobbler
  module REST
  	class Connection
  	  # reads xml fixture file instead of hitting up the internets
  	  def request(resource, method = "get", args = nil)
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
	    end
	  end
  end
end