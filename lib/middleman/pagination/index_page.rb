module Middleman
  module Pagination
    class IndexPage

      attr_reader :context, :first_index, :pageable_context, :page_num, :symbolic_replacement_path

      def initialize(context, first_index, pageable_context, page_num, symbolic_replacement_path)
        @context = context
        @first_index = first_index
        @pageable_context = pageable_context
        @page_num = page_num
        @symbolic_replacement_path = symbolic_replacement_path
      end

      def resource
        res = ::Middleman::Sitemap::Resource.new(sitemap, path, source_file)
        res.add_metadata(metadata)
        res
      end

      private

      def source_file
        first_index.source_file
      end

      def sitemap
        context.sitemap
      end

      def path
        IndexPath.new(context, first_index.path, page_num, symbolic_replacement_path).to_s
      end

      def metadata
        { locals: locals }
      end

      def locals
        { pagination: in_page_context }
      end

      def in_page_context
        InPageContext.new(pageable_context: pageable_context, page_num: page_num)
      end

    end
  end
end