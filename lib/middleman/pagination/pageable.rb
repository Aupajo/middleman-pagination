module Middleman
  module Pagination
    class Pageable

      attr_reader :name, :block

      def initialize(name, &block)
        @name = name
        @block = block
      end

    end
  end
end