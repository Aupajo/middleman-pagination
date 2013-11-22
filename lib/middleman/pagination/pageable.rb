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

      def new_pages_for_index(context, index, resources)
        symbolic_replacement_path = pagination_data(index, :path)

        pageable_context = PageableContext.new(
          per_page: pagination_data(index, :per_page) || 20,
          resources: set(resources),
          index_resources: [index]
        )

        add_pagination_to(index, pageable_context: pageable_context, page_num: 1)

        (2..pageable_context.total_page_num).map do |n|
          new_page_for_index(context, index, pageable_context, n, symbolic_replacement_path)
        end
      end

      def new_page_for_index(context, index, pageable_context, page_num, symbolic_replacement_path)
        sitemap = context.sitemap
        path = IndexPath.new(context, index.path, page_num, symbolic_replacement_path).to_s
        source_file = index.source_file

        new_index = ::Middleman::Sitemap::Resource.new(sitemap, path, source_file)
        add_pagination_to(new_index, pageable_context: pageable_context, page_num: page_num)
        
        pageable_context.index_resources << new_index

        new_index
      end

      private

      def add_pagination_to(resource, attributes = {})
        in_page_context = InPageContext.new(attributes)
        resource.add_metadata(locals: { 'pagination' => in_page_context })
      end

      # TODO remove duplicate methods once refactoring has finished
      
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