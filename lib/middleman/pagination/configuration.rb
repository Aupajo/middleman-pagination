module Middleman
  module Pagination
    class Configuration
      include Enumerable
      
      def initialize
        @pageable = {}
      end

      def pageable(name, &block)
        @pageable[name] = Pageable.new(name, resource_filter: block)
      end

      def pageable_set(name, &block)
        @pageable[name] = Pageable.new(name, set: block)
      end

      def each(&block)
        @pageable.each do |name, pageable_obj|
          yield pageable_obj
        end
      end
    end
  end
end