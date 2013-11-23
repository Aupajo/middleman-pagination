module Middleman
  module Pagination
    class IndexPath
      attr_accessor :extension_context, :original_path, :page_num, :symbolic_path_replacement

      def initialize(extension_context, original_path, page_num, symbolic_path_replacement = nil)
        @extension_context = extension_context
        @original_path = original_path
        @symbolic_path_replacement = symbolic_path_replacement || 'pages/:num'

        if page_num < 1
          raise "Expected page_num greater than 0 (page numbers are not zero-indexed"
        end

        @page_num = page_num
      end

      def to_s
        if first_index?
          original_path
        else
          replaced_path
        end
      end

      private

      def first_index?
        page_num == 1
      end

      def replaced_path
        if original_path.match(index_file_pattern)
          original_path.sub(index_file_pattern, "\\1#{replaced_symbolic_path}\\2")
        else
          original_path.sub(non_index_path_pattern, "\\1\\2/#{replaced_symbolic_path}.\\3")
        end
      end

      def index_file_pattern
        index_file_ext = File.extname(extension_context.index_file)
        index_file_path = extension_context.index_file.delete(index_file_ext)

        %r{
          (/)?                                # An optional slash
          #{Regexp.escape(index_file_path)}   # Followed by the index path (usually "index")
          (#{Regexp.escape(index_file_ext)})  # Followed by the index extension (usually ".html")
          $                                   # Followed by the end of the string  
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

      def replaced_symbolic_path
        symbolic_path_replacement.sub(':num', page_num.to_s)
      end

    end
  end
end
