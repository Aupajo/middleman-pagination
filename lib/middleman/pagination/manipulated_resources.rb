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
        context.configuration.map do |name, filter|

          original_resources.map do |resource|

            if resource.data.pagination.try(:for) == name.to_s

              pageable_context = PageableContext.new(
                per_page: resource.data.pagination.per_page || 20,
                resources: original_resources.select(&filter),
                index_resources: [resource]
              )

              in_page_context = InPageContext.new(
                pageable_context: pageable_context,
                page_num: 1
              )

              resource.add_metadata(:locals => { 'pagination' => in_page_context })

              (2..pageable_context.total_page_num).map do |n|

                sitemap = context.sitemap
                # TODO use app.index_file
                path = resource.path.sub(/index\.html$/, "pages/#{n}.html")
                source_file = resource.source_file

                new_index = ::Middleman::Sitemap::Resource.new(sitemap, path, source_file)
                
                in_page_context = InPageContext.new(
                  pageable_context: pageable_context,
                  page_num: n
                )

                new_index.add_metadata(:locals => { 'pagination' => in_page_context })
                pageable_context.index_resources << new_index
                new_index

              end

            end

          end.compact

        end.flatten
      end
    end
  end
end