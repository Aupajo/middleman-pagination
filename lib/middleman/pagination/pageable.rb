module Middleman
  module Pagination
    class Pageable

      attr_reader :name, :block
      alias :filter :block

      def initialize(name, &block)
        @name = name
        @block = block
      end

      def set(resources)
        set_from_filter(resources)
      end

      def pagination_indexes(resources)
        Enumerator.new do |enum| 
          resources.each do |resource|
            if !resource.ignored? && pagination_data(resource, :for) == name.to_s
              enum.yield resource
            end
          end
        end
      end

      private

      # TODO remove duplicate method once refactoring has finished
      def pagination_data(resource, key)
        keys = [:pagination, key]

        [resource.data, resource.metadata[:options]].inject(nil) do |result, data_source|
          result or keys.inject(data_source) { |source, key| source.try(:[], key) }
        end
      end

      def set_from_filter(resources)
        resources.select do |resource|
          next if resource.ignored?
          filter.call(resource)
        end.sort_by(&:path)
      end

    end
  end
end