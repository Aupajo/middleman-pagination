module Middleman
  module Pagination
    class Configuration
      include Enumerable
      
      def initialize
        @pageable = {}
      end

      def pageable(name, &block)
        warn "`pageable` is deprecated, use `pageable_resource` instead"
        pageable_resource(name, &block)
      end

      def pageable_resource(name, &block)
        @pageable[name] = Pageable.new(name) do
          resources.select do |resource|
            next if resource.ignored?
            block.call(resource)
          end.sort_by(&:path)
        end
      end

      def pageable_set(name, &block)
        @pageable[name] = Pageable.new(name, &block)
      end

      def each(&block)
        @pageable.each do |name, pageable_obj|
          yield pageable_obj
        end
      end

    end
  end
end