module Middleman
  module Pagination
    class IndexPath
      attr_accessor :context, :original_path, :page_num, :symbolic_path_replacement

      def initialize(context, original_path, page_num, symbolic_path_replacement = 'pages/:num')
        @context = context
        @original_path = original_path
        @symbolic_path_replacement = symbolic_path_replacement

        if page_num < 1
          raise "Expected page_num greater than 0 (page numbers are not zero-indexed"
        end

        @page_num = page_num
      end

      def to_s
        if page_num == 1
          original_path
        else
          if original_path.match(index_file_pattern)
            original_path.sub(index_file_pattern, "\\1#{replaced_path}.html")
          else
            original_path.sub(non_index_path_pattern, "\\1\\2/#{replaced_path}.\\3")
          end
        end
      end

      private

      def index_file_pattern
        %r{
          (/)?                                  # An optional slash
          #{Regexp.escape(context.index_file)}  # Followed by the index file (usually "index.html")
          $                                     # Followed by the end of the string  
        }x
      end

      def non_index_path_pattern
        %r{
          (^|/)   # Match the start of the string or a slash
          ([^/]*) # Followed by any character not a slash
          \.      # Followed by a dot
          ([^/]*) # Followed by any character not a slash
          $       # Followed by the end of the string
        }x
      end

      def replaced_path
        symbolic_path_replacement.sub(':num', page_num.to_s)
      end

    end
  end
end
