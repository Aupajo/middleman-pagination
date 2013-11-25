module Middleman
  module Pagination
    class InPageContext < OpenStruct
      extend Forwardable
      include Enumerable

      def_delegators :pageable_context, :set,
                                        :index_resources,
                                        :total_page_num,
                                        :per_page,
                                        :first_page,
                                        :last_page

      def next_page
        index_resources[page_num]
      end

      def prev_page
        index_resources[page_num - 2] if page_num > 1
      end

      def subset
        num_previous = per_page * (page_num - 1)
        set.drop(num_previous).take(per_page)
      end

      def each(&block)
        subset.each(&block)
      end
    end
  end
end