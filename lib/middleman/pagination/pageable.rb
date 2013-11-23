module Middleman
  module Pagination
    class Pageable

      attr_reader :name, :resource_filter

      def initialize(name, options = {})
        @name = name
        @resource_filter = options[:resource_filter]
        @set = options[:set]
      end

      def new_resources(context, resources)
        pagination_indexes(resources).map do |resource|
          new_pages_for_index(context, resource, resources)
        end.compact
      end

      private

      def set(resources)
        if @set
          @set.call
        else
          set_from_resource_filter(resources)
        end
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
          set: set(resources),
          index_resources: [index]
        )

        add_pagination_to(index, pageable_context: pageable_context, page_num: 1)

        (2..pageable_context.total_page_num).map do |page_num|
          new_index = IndexPage.new(context,
                                    index,
                                    pageable_context,
                                    page_num,
                                    symbolic_replacement_path).resource

          pageable_context.index_resources << new_index

          new_index
        end
      end

      def add_pagination_to(resource, attributes = {})
        in_page_context = InPageContext.new(attributes)
        resource.add_metadata(locals: { 'pagination' => in_page_context })
      end
      
      def pagination_data(resource, key)
        keys = [:pagination, key]

        [resource.data, resource.metadata[:options]].inject(nil) do |result, data_source|
          result or keys.inject(data_source) { |source, key| source.try(:[], key) }
        end
      end

      def set_from_resource_filter(resources)
        resources.select do |resource|
          next if resource.ignored?
          resource_filter.call(resource)
        end.sort_by(&:path)
      end

    end
  end
end