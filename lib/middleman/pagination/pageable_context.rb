module Middleman
  module Pagination
    class PageableContext < OpenStruct
      def total_page_num
        (set.length.to_f / per_page).ceil
      end

      def first_page
        index_resources.first
      end

      def last_page
        index_resources.last
      end
    end
  end
end