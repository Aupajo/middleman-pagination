module Middleman
  module Pagination
    class ManipulatedResources
      attr_reader :context, :original_resources

      def initialize(context, resources)
        @context = context
        @original_resources = resources
      end

      def resource_list
        original_resources + new_resources
      end

      private

      def new_resources
        context.configuration.map do |pageable|
          new_resources_for_pageable(pageable)
        end.flatten
      end

      def new_resources_for_pageable(pageable)
        set = pageable.set(original_resources)

        pageable.pagination_indexes(original_resources).map do |resource|
          pageable.new_pages_for_index(context, resource, original_resources)
        end.compact
      end

      def pagination_data(resource, key)
        keys = [:pagination, key]

        [resource.data, resource.metadata[:options]].inject(nil) do |result, data_source|
          result or keys.inject(data_source) { |source, key| source.try(:[], key) }
        end
      end
      
      def add_pagination_to(resource, attributes = {})
        in_page_context = InPageContext.new(attributes)
        resource.add_metadata(locals: { 'pagination' => in_page_context })
      end
    end
  end
end