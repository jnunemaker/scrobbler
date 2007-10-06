module Scrobbler
  
  API_URL     = 'http://ws.audioscrobbler.com/'
  API_VERSION = '1.0'
  
  class Base
    class << self
      def connection
        @connection ||= REST::Connection.new(API_URL)
      end
      
      def fetch_and_parse(resource)
        Hpricot::XML(connection.get(resource))
      end
    end
    
    private
      # in order for subclass to use, it must have api_path method
      def get_instance(api_method, instance_name, element, force=false)
        scrobbler_class = "scrobbler/#{element.to_s}".camelize.constantize
        if instance_variable_get("@#{instance_name}").nil? || force
          doc      = self.class.fetch_and_parse("#{api_path}/#{api_method}.xml")
          elements = (doc/element).inject([]) { |elements, el| elements << scrobbler_class.new_from_xml(el, doc); elements }
          instance_variable_set("@#{instance_name}", elements)
        end
        instance_variable_get("@#{instance_name}")
      end
  end
end