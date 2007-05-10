module Scrobbler
  class Chart < Base
    class << self
      def new_from_xml(xml, doc)
        Chart.new(xml['from'], xml['to'])
      end
    end
    def initialize(from, to)
      raise ArgumentError, "From is required" if from.blank?
      raise ArgumentError, "To is required" if to.blank?
      @from = from
      @to = to
    end
    
    def from=(value)
      @from = value.to_i
    end
    
    def to=(value)
      @to = value.to_i
    end
    
    def from
      @from.to_i
    end
    
    def to
      @to.to_i
    end
  end
end