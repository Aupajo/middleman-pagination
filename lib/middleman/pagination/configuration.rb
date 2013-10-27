module Middleman
  module Pagination
    class Configuration
      include Enumerable
      
      def initialize
        @pageable = {}
      end

      def pageable(name, &block)
        @pageable[name] = block
      end

      def each(&block)
        @pageable.each(&block)
      end
    end
  end
end