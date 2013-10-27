module Middleman
  module Pagination
    class ManipulatedResources
      attr_reader :context, :original_resources

      def initialize(context, resources)
        @context = context
        @original_resources = resources
      end

      def resource_list
        modified_resources + new_resources
      end

      private

      def modified_resources
        # TODO
        original_resources
      end

      def new_resources
        context.configuration.map do |name, filter|
          new_resources_for(name, filter)
        end.flatten
      end

      def new_resources_for(name, filter)
        original_resources.map do |resource|
          if resource.data.pagination.try(:for) == name.to_s
            new_resources_for_index(resource, filter)
          end
        end.compact
      end

      def new_resources_for_index(resource, filter)
        per_page = resource.data.pagination.per_page || 20
        matches = original_resources.select(&filter)
        total_page_num = (matches.length.to_f / per_page).ceil

        (2..total_page_num).map do |n|
          # TODO use app.index_file
          path = resource.path.sub(/index\.html$/, "pages/#{n}.html")
          sitemap = context.sitemap
          source_file = resource.source_file

          # TODO add metadata
          ::Middleman::Sitemap::Resource.new(sitemap, path, source_file)
        end
      end
    end
  end
end