module Middleman
  module Pagination
    class IndexPath
      attr_accessor :context, :original_path, :page_num

      def initialize(context, original_path, page_num)
        @context = context
        @original_path = original_path
        @page_num = page_num
      end

      def to_s
        symbolic_path_replacement = "pages/:num"
        pattern = %r{^?(/)?#{Regexp.escape(context.index_file)}$}
        replacement = symbolic_path_replacement.sub(':num', page_num.to_s)

        if original_path.match(pattern)
          original_path.sub(pattern, "\\1#{replacement}.html")
        else
          original_path.sub(%r{(^|/)([^/]*)\.([^/]*)$}, "\\1\\2/#{replacement}.\\3")
        end
      end
    end
  end
end
